import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync, readdirSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';
import { parseOptions, renderSvg, resolveSvgVariables } from './cli.mjs';

const executable = fileURLToPath(new URL('../../bin/mmdc', import.meta.url));
const source = 'flowchart LR\n  A[Markdown] --> B{Renderer}\n  B --> C[Pele SVG]\n  B --> D[PNG for Snacks]';
const run = (args, options = {}) => spawnSync(process.execPath, [executable, ...args], {
  input: source,
  encoding: 'utf8',
  timeout: 10000,
  ...options,
});

function withDirectory(callback) {
  const directory = mkdtempSync(join(tmpdir(), 'pele-test-'));
  try {
    return callback(directory);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

test('accepts the exact flags used by Snacks', () => {
  const options = parseOptions(['-i', 'source.mmd', '-o', 'image.png', '-b', 'transparent', '-t', 'dark', '--scale', '1.5', '-q']);
  assert.equal(options.input, 'source.mmd');
  assert.equal(options.output, 'image.png');
  assert.equal(options.scale, 1.5);
  assert.equal(options.theme, 'dark');
  assert.equal(options.background, 'transparent');
  assert.equal(options.quiet, true);
});

test('rejects unsupported flags, themes, formats, and invalid dimensions', () => {
  for (const args of [['--unknown'], ['-t', '__proto__'], ['-o', 'image.jpg'], ['-s', '0'], ['--scale', 'NaN'], ['-w', '-2'], ['-H', 'Infinity'], ['-i']]) {
    assert.throws(() => parseOptions(args));
  }
  assert.equal(parseOptions(['-t', 'default', '-s', '2']).theme, 'neutral');
});

test('resolves Gruvbox colors while leaving diagram labels alone', () => {
  const input = 'flowchart LR\n  A["var(--example)"] --> B["Gruvbox"]';
  const dark = renderSvg(input, 'dark');
  const light = renderSvg(input, 'neutral');
  assert.match(dark, />var\(--example\)</);
  assert.match(dark, /stroke="#ebdbb2"/);
  assert.match(dark, /fill="#3c3836"/);
  assert.match(light, /stroke="#3c3836"/);
  assert.match(light, /fill="#ebdbb2"/);
  assert.doesNotMatch(dark, /(?:style|fill|stroke)="[^"]*var\(/);
  assert.doesNotMatch(dark, /<rect width="100%"/);
});

test('resolves nested aliases, CSS function fallbacks, and detects cycles', () => {
  const svg = '<svg style="--tone:var(--missing,rgb(12,34,56));--alias:var(--tone)"><path fill="var(--alias)"/></svg>';
  assert.match(resolveSvgVariables(svg, 'dark'), /fill="rgb\(12,34,56\)"/);
  assert.throws(() => resolveSvgVariables('<svg style="--a:var(--b);--b:var(--a)"/>', 'dark'), /Cyclic/);
  assert.throws(() => resolveSvgVariables('<svg><path fill="var(--missing)"/></svg>', 'dark'), /Unresolved/);
});

test('renders sequence, state, class, ER, and chart diagrams', () => {
  for (const input of [
    'sequenceDiagram\n  Alice->>Bob: Hello',
    'stateDiagram-v2\n  [*] --> Ready\n  Ready --> [*]',
    'classDiagram\n  class Example {\n    +String name\n  }',
    'erDiagram\n  USER ||--o{ ORDER : places',
    'pie\n  "One" : 10\n  "Two" : 20',
  ]) {
    const svg = renderSvg(input, 'dark');
    assert.match(svg, /<svg/);
    assert.doesNotMatch(svg, /var\(/);
  }
});

test('the real mmdc executable provides help, version, and SVG on stdout', () => {
  const help = run(['--help']);
  assert.equal(help.status, 0, help.stderr);
  assert.match(help.stdout, /Render Mermaid diagrams with Pele/);
  const version = run(['--version']);
  assert.equal(version.status, 0, version.stderr);
  assert.equal(version.stdout.trim(), 'pele 1.6.0');
  const svg = run(['-i', '-', '-t', 'dark']);
  assert.equal(svg.status, 0, svg.stderr);
  assert.match(svg.stdout, /^<svg/);
  assert.equal(svg.stderr, '');
});

test('writes transparent PNGs and honors scaling and dimensions', () => withDirectory((directory) => {
  const png = join(directory, 'image.png');
  const first = run(['-i', '-', '-o', png, '-t', 'dark', '-b', 'transparent', '--scale', '1', '-q']);
  assert.equal(first.status, 0, first.stderr);
  assert.equal(first.stderr, '');
  const image = readFileSync(png);
  assert.equal(image.subarray(1, 4).toString(), 'PNG');
  const width = image.readUInt32BE(16);
  const height = image.readUInt32BE(20);
  const pixel = spawnSync('magick', [png, '-format', '%[fx:p{0,0}.a]', 'info:'], { encoding: 'utf8' });
  assert.equal(pixel.status, 0, pixel.stderr);
  assert.equal(pixel.stdout, '0');
  const doubled = run(['-o', png, '-t', 'dark', '-s', '2', '-q']);
  assert.equal(doubled.status, 0, doubled.stderr);
  const scaled = readFileSync(png);
  assert.equal(scaled.readUInt32BE(16), width * 2);
  assert.equal(scaled.readUInt32BE(20), height * 2);
  const sized = run(['-o', png, '-w', '800', '--scale', '3', '-q']);
  assert.equal(sized.status, 0, sized.stderr);
  assert.equal(readFileSync(png).readUInt32BE(16), 800);
  assert.deepEqual(readdirSync(directory), ['image.png']);
}));

test('supports opaque backgrounds and SVG/PDF output', () => withDirectory((directory) => {
  const svg = join(directory, 'image.svg');
  const written = run(['-o', svg, '-b', '#282828', '-q']);
  assert.equal(written.status, 0, written.stderr);
  assert.match(readFileSync(svg, 'utf8'), /<rect width="100%" height="100%" fill="#282828"\/>/);
  const pdf = join(directory, 'image.pdf');
  const converted = run(['-o', pdf, '-q']);
  assert.equal(converted.status, 0, converted.stderr);
  assert.equal(readFileSync(pdf).subarray(0, 4).toString(), '%PDF');
}));

test('reports errors without leaving partial images or temporary files', () => withDirectory((directory) => {
  const output = join(directory, 'image.png');
  const invalid = run(['-o', output, '-q'], { input: 'not a diagram' });
  assert.notEqual(invalid.status, 0);
  assert.match(invalid.stderr, /mmdc:/);
  const missing = run(['-o', output, '-q'], { env: { ...process.env, PATH: directory } });
  assert.notEqual(missing.status, 0);
  assert.match(missing.stderr, /brew install librsvg/);
  assert.deepEqual(readdirSync(directory), []);
}));
