# dotfiles

```
git clone https://github.com/MortenGerdes/dotfiles.git
```

```
cd ~/dotfiles
```

```
ls --color=never | xargs -I {} stow {}
```

## Mermaid diagrams

Neovim uses [Pele](https://pele.run/) through `mmdc` for Mermaid diagrams, with
Gruvbox light/dark colors and a transparent canvas. Snacks displays the images;
`render-markdown.nvim` handles the rest of the Markdown formatting.

Install the renderer dependencies after cloning:

```sh
brew install node librsvg
npm ci --prefix ~/dotfiles/bin/.local/share/pele --ignore-scripts
```

Test the renderer (the PNG transparency test also requires ImageMagick):

```sh
npm test --prefix ~/dotfiles/bin/.local/share/pele
```
