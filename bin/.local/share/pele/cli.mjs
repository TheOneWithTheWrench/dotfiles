import { mkdtempSync, readFileSync, renameSync, rmSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, extname, join, resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import { parseArgs } from 'node:util';
import { render } from 'pele';

const { version } = createRequire(import.meta.url)('pele/package.json');
const palettes = {
  dark: {
    '--pele-bg': '#282828',
    '--pele-fg': '#ebdbb2',
    '--pele-muted': '#a89984',
    '--pele-line': '#ebdbb2',
    '--pele-surface': '#3c3836',
    '--pele-surface-alt': '#504945',
    '--pele-border': '#928374',
    '--pele-accent': '#83a598',
    '--pele-critical': '#fb4934',
    '--pele-series-1': '#83a598',
    '--pele-series-2': '#fabd2f',
    '--pele-series-3': '#b8bb26',
    '--pele-series-4': '#fb4934',
    '--pele-series-5': '#8ec07c',
    '--pele-series-6': '#fe8019',
    '--pele-series-7': '#d3869b',
    '--pele-series-8': '#a89984',
  },
  neutral: {
    '--pele-bg': '#fbf1c7',
    '--pele-fg': '#3c3836',
    '--pele-muted': '#7c6f64',
    '--pele-line': '#3c3836',
    '--pele-surface': '#ebdbb2',
    '--pele-surface-alt': '#d5c4a1',
    '--pele-border': '#928374',
    '--pele-accent': '#076678',
    '--pele-critical': '#9d0006',
    '--pele-series-1': '#076678',
    '--pele-series-2': '#b57614',
    '--pele-series-3': '#79740e',
    '--pele-series-4': '#9d0006',
    '--pele-series-5': '#427b58',
    '--pele-series-6': '#af3a03',
    '--pele-series-7': '#8f3f71',
    '--pele-series-8': '#7c6f64',
  },
};

const help = `Render Mermaid diagrams with Pele ${version} (no Mermaid.js or browser).

Usage: mmdc -i diagram.mmd -o diagram.png [options]

  -i, --input FILE       Mermaid source, or - for stdin (default)
  -o, --output FILE      PNG, SVG, or PDF output (default: SVG to stdout)
  -t, --theme THEME      dark, neutral, or default (default: neutral)
  -b, --background CSS   Background color (default: transparent)
  -s, --scale NUMBER     PNG/PDF size multiplier (default: 1)
  -w, --width NUMBER     Output width in pixels; overrides scale
  -H, --height NUMBER    Output height in pixels; overrides scale
  -q, --quiet           Suppress status messages
  -h, --help            Show this help
  -v, --version         Show the Pele version

Requires Node >=20 and rsvg-convert for PNG/PDF output.
`;

export function parseOptions(args) {
  const { values } = parseArgs({
    args,
    options: {
      input: { type: 'string', short: 'i', default: '-' },
      output: { type: 'string', short: 'o' },
      theme: { type: 'string', short: 't', default: 'neutral' },
      background: { type: 'string', short: 'b', default: 'transparent' },
      scale: { type: 'string', short: 's', default: '1' },
      width: { type: 'string', short: 'w' },
      height: { type: 'string', short: 'H' },
      quiet: { type: 'boolean', short: 'q', default: false },
      help: { type: 'boolean', short: 'h', default: false },
      version: { type: 'boolean', short: 'v', default: false },
    },
  });
  if (values.help || values.version) return values;
  if (values.theme === 'default') values.theme = 'neutral';
  if (!Object.hasOwn(palettes, values.theme)) throw new Error(`Unknown theme: ${values.theme}`);
  for (const name of ['scale', 'width', 'height']) {
    if (values[name] === undefined) continue;
    values[name] = Number(values[name]);
    if (!Number.isFinite(values[name]) || values[name] <= 0) {
      throw new Error(`${name} must be a positive number`);
    }
  }
  values.format = values.output ? extname(values.output).slice(1).toLowerCase() : 'svg';
  if (!['svg', 'png', 'pdf'].includes(values.format)) {
    throw new Error('Output filename must end in .svg, .png, or .pdf');
  }
  return values;
}

function resolveCss(value, variables, seen = new Set()) {
  let result = '';
  let offset = 0;
  let start;
  while ((start = value.indexOf('var(', offset)) !== -1) {
    let end = start + 4;
    let depth = 1;
    while (end < value.length && depth > 0) {
      if (value[end] === '(') depth++;
      if (value[end] === ')') depth--;
      end++;
    }
    if (depth !== 0) throw new Error('Unclosed CSS variable in Pele SVG');
    const expression = value.slice(start + 4, end - 1);
    const comma = expression.indexOf(',');
    const name = (comma === -1 ? expression : expression.slice(0, comma)).trim();
    const replacement = variables.get(name) ?? (comma === -1 ? undefined : expression.slice(comma + 1).trim());
    if (replacement === undefined) throw new Error(`Unresolved SVG color variable: ${name}`);
    if (seen.has(name) || seen.size > 32) throw new Error(`Cyclic SVG variable: ${name}`);
    const next = variables.has(name) ? new Set([...seen, name]) : seen;
    result += value.slice(offset, start) + resolveCss(replacement, variables, next);
    offset = end;
  }
  return result + value.slice(offset);
}

export function resolveSvgVariables(svg, theme) {
  const rootStyle = svg.match(/<svg\b[^>]*\sstyle="([^"]*)"/)?.[1] ?? '';
  const variables = new Map();
  for (const declaration of rootStyle.split(';')) {
    const colon = declaration.indexOf(':');
    const name = declaration.slice(0, colon).trim();
    if (name.startsWith('--')) variables.set(name, declaration.slice(colon + 1).trim());
  }
  for (const [name, value] of Object.entries(palettes[theme])) variables.set(name, value);

  // librsvg does not resolve Pele's CSS variables. Only rewrite styling attributes, never labels.
  return svg.replace(/<[^>]*>/g, (tag) => tag.replace(
    /(\s(?:style|fill|stroke|color|font-family|font-weight|stroke-width|rx|ry|stop-color)=")([^"]*)(")/g,
    (_, prefix, value, suffix) => prefix + resolveCss(value, variables) + suffix,
  ));
}

export function renderSvg(source, theme) {
  const { svg } = render(source, {
    responsive: false,
    autoDirection: false,
    fontFamily: 'Arial',
    links: false,
    images: false,
  });
  return resolveSvgVariables(svg, theme);
}

function saveImage(svg, options) {
  const output = resolve(options.output);
  const temporary = mkdtempSync(join(dirname(output), '.pele-'));
  const file = join(temporary, `image.${options.format}`);
  try {
    if (options.format === 'svg') {
      writeFileSync(file, svg);
    } else {
      const args = ['--format', options.format, '--output', file];
      if (options.width || options.height) {
        args.push('--keep-aspect-ratio');
        if (options.width) args.push('--width', String(options.width));
        if (options.height) args.push('--height', String(options.height));
      } else {
        args.push('--zoom', String(options.scale));
      }
      const result = spawnSync('rsvg-convert', args, {
        input: svg,
        encoding: 'utf8',
        timeout: 30000,
      });
      if (result.error?.code === 'ENOENT') {
        throw new Error('rsvg-convert is required for PNG/PDF output (brew install librsvg)');
      }
      if (result.error) throw result.error;
      if (result.status !== 0) throw new Error(result.stderr.trim() || 'SVG rasterization failed');
    }
    renameSync(file, output);
  } finally {
    rmSync(temporary, { recursive: true, force: true });
  }
}

export function main(args) {
  const options = parseOptions(args);
  if (options.help) return process.stdout.write(help);
  if (options.version) return process.stdout.write(`pele ${version}\n`);
  const source = readFileSync(options.input === '-' ? 0 : options.input, 'utf8');
  let svg = renderSvg(source, options.theme);
  if (options.background !== 'transparent') {
    const color = options.background.replace(/[&<>"']/g, (char) => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&apos;',
    })[char]);
    svg = svg.replace(/<svg\b[^>]*>/, (root) => `${root}<rect width="100%" height="100%" fill="${color}"/>`);
  }
  if (!options.output) return process.stdout.write(svg + '\n');
  saveImage(svg, options);
  if (!options.quiet) process.stderr.write(`Pele: wrote ${options.output}\n`);
}
