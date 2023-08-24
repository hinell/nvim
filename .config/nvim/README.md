<h1 align="center">HINELL/nvim</h1>


![Neovim config preview](doc/preview-2.png)
![Neovim config preview](doc/preview-3.png)
![Neovim config preview](doc/preview-4.png)
![Neovim config preview](doc/preview-5.png)

## Install


### Install dependencies
This config depends on [packer] for plugin management and installation. I don't use lazyvim cause it has serious drawbacks (despite better UX).

#### Clibpoard
Nvim doesn't provide builtin clipboard support so you have to install clipboard provider. I suggset to use `xclip`.

#### Searching
**[ripgrep](https://github.com/BurntSushi/ripgrep#installation)** - This one is used by [Telescope]

#### Fonts
**[Nerd fonts](https://github.com/ryanoasis/nerd-fonts/)**
```sh
# Example of a shell script installing nerdfont JetBrainsMono

local FONTNAME="JetBrainsMono"
fc-list -q "${FONTNAME} Nerd Font Mono" || {
    local TEMPDIR=$(mktemp -d)
    git clone --depth 1 --filter=blob:none \
        --sparse git@github.com:ryanoasis/nerd-fonts.git "$TEMPDIR"
    pushd "$TEMPDIR"
    git sparse-checkout add patched-fonts/${FONTNAME}
    fc-list -q %s
    ./install.sh -s -S ${FONTNAME}
    popd
}
```
#### LSP Servers


You may use `williamboman/mason.nvim` to install LSP servers & other tools.
See [lsp-config/server_configurations.md] for the list of LSP servers.
Every LSP serever listed below requries a separate installation of the binary or script.
Check out `setup.sh` executable next to this file.

| Languages, | LSP name | Summary |
|-|-|-|
| c/c++ | [clangd][lsp-config-clangd] | |
| lua   | luals | |
| sh,bash,zsh   | [bashls](https://github.com/bash-lsp/bash-language-server) | Basic shell LSP server; quirky when works with `zsh` |
| * | [mattn/efm-languageserver](https://github.com/mattn/efm-langserver) | General purpose server; see configs at [creativenull/efmls-configs-nvim](https://github.com/creativenull/efmls-configs-nvim) |
| javascript, typescript | [tsserver](https://github.com/typescript-language-server/typescript-language-server) | TypeScript server from Micro$$oft; pretty slow |
| json | [vscode-langservers-extracted] | Requires [Node.js] installation; checkout `nvm` manager for `*nix` platforms|
| css, scss, less | [vscode-langservers-extracted] | Requires [Node.js]; use `npm` to install |
| html | [vscode-langservers-extracted] | Requires [Node.js]; use `npm` to install |
| sql | [sqlls](https://github.com/joe-re/sql-language-server) | Requires [Node.js]; use `npm` to install |
| yamlls | [yamlls](https://github.com/redhat-developer/yaml-language-server) | Requires [Node.js]; use `npm` to install |

[vscode-langservers-extracted]: (https://github.com/hrsh7th/vscode-langservers-extracted) "vscode-langservers bin collection"

### Troubleshooting
Run `:checkhealth` command to see if something wrong with your installation.

[lsp-config-clangd]: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
[lsp-config/server_configurations.md]: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md 'LSP Config Server Configurations list'
[packer]: https://github.com/wbthomason/packer.nvim
[Node.js]: https://github.com/nodejs/node

### Usage

```vim
" ~/.config/nvim/init.vim
lua require("hinell")
```

### Plugins: UI
|Plugin name|Summary|
|-|-|
| [`wbthomason/packer.nvim`](https://github.com/wbthomason/packer.nvim)                                     | Packaging manager                                                                                              |
| [`williamboman/mason.nvim`](https://github.com/williamboman/mason.nvim)                                   | Package manager to install LSP & DAP servers, linters, and formatters                                          |
| [`williamboman/mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim)               | Integration with lspconfig                                                                                     |
| [`hrsh7th/nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)                                                 | Completion engine                                                                                              |
| [`L3MON4D3/LuaSnip`](https://github.com/L3MON4D3/LuaSnip)                                                 | Snippet Engine for Neovim written in Lua. Supports TextMate (VS Code) snippets.                                |
| [`lukas-reineke/cmp-under-comparator`](https://github.com/lukas-reineke/cmp-under-comparator)             | Better nvim-cmp sorting function                                                                               |
| [`sindrets/diffview.nvim`](https://github.com/sindrets/diffview.nvim)                                     | Diffviewer                                                                                                     |
| [`mrjones2014/legendary.nvim`](https://github.com/mrjones2014/legendary.nvim)                             | Command pallette                                                                                               |
| [`gaborvecsei/memento.nvim`](https://github.com/gaborvecsei/memento.nvim)                                 | Upon startup put the cursor on the last editing place                                                          |
| [`simrat39/symbols-outline.nvim`](https://github.com/simrat39/symbols-outline.nvim)                       | A tree view of symbols/outline code structure (see also [aaeral.nvim](https://github.com/stevearc/aerial.nvim))|
| [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim)                                       | Utils library                                                                                                  |
| [`stevearc/dressing.nvim`](https://github.com/stevearc/dressing.nvim)                                     | UI library for salect, input etc .                                                                             |
| [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)                               | Statusline                                                                                                     |
| [`luukvbaal/statuscol.nvim`](https://github.com/luukvbaal/statuscol.nvim)                                 | Statuscolumn                                                                                                   |
| [`lukas-reineke/indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim)           | Display thin lines of indentation.                                                                             |
| [`lukas-reineke/virt-column.nvim`](https://github.com/lukas-reineke/virt-column.nvim)                     | Display dots for indent columns                                                                                |
| [`akinsho/bufferline.nvim`](https://github.com/akinsho/bufferline.nvim)                                   | Tabline                                                                                                        |
| [`karb94/neoscroll.nvim`](https://github.com/karb94/neoscroll.nvim)                                       | Not used; the plugin may slow down nvim                                                                        |
| [`axieax/urlview.nvim`](https://github.com/axieax/urlview.nvim)                                           | Navigate across URLs inside buffer                                                                             |
| [`utilyre/barbecue.nvim`](https://github.com/utilyre/barbecue.nvim)                                       | Context status line under tab (VS Code like winbar)                                                            |
| [`aca/emmet-ls`](https://github.com/aca/emmet-ls)                                                         | Emmet html-expansion engine                                                                                    |
| [`akinsho/git-conflict.nvim`](https://github.com/akinsho/git-conflict.nvim)                               | Visualise and resolve merge conflicts in neovim                                                                |
| [`iamcco/markdown-preview.nvim`](https://github.com/iamcco/markdown-preview.nvim)                         | Preview markdown files in browser                                                                              |
| [`sunjon/shade`](https://github.com/sunjon/shade.nvim)                                                    | An Nvim lua plugin that dims your inactive windows |
| [`mvllow/modes.nvim`](https://github.com/mvllow/modes.nvim) | Higlight cursor, cursor line, column number |

### Plugins: Editor
|Plugin name|Summary|
|-|-|
| [`andymass/vim-matchup`](https://github.com/andymass/vim-matchup) | Navigate and highlight matching words; modern matchit and matchparen (%) |
| [`LunarVim/bigfile.nvim`](https://github.com/LunarVim/bigfile.nvim) | Tweaks for editing big files; turns off many NVIM features like highlighting etc. |
| [`taybart/b64.nvim`](https://github.com/taybart/b64.nvim) | Base64 conversion nvim command |
| [`numToStr/Comment.nvim`](https://github.com/numToStr/Comment.nvim)                                       | Toggle comment                                                                                                 |
| [`wintermute-cell/gitignore.nvim`](https://github.com/wintermute-cell/gitignore.nvim)                     | Scaffold `.gitignore`                                                                                          |

### Plugins: LSP integration
|Plugin name|Summary|
|-|-|
| [`neovim/nvim-lspconfig)`](https://github.com/neovim/nvim-lspconfig)                                      | Diagnostics from LSP                                                                                           |
| [`nvim-lua/lsp-status.nvim`](https://github.com/nvim-lua/lsp-status.nvim)                                 | Diagnostics from LSP                                                                                           |

### Plugins: Telescope
|Plugin name|Summary|
|-|-|
| [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)                       | UI palettes for various actions                                                                                |
| [`nvim-telescope/telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Telescope extension using fzf search lib                                                                       |
| [`benfowler/telescope-luasnip.nvim`](https://github.com/benfowler/telescope-luasnip.nvim)                 | Telescope luasnip integration                                                                                  |
| [`olacin/telescope-cc.nvim`](https://github.com/olacin/telescope-cc.nvim)                                 | Telescope integration for conventional Commits                                                                 |
| [`folke/todo-comments.nvim`](https://github.com/folke/todo-comments.nvim)                                 | Telescope extension for listing Todo comments                                                                  |
| [`telescope-insert-path.nvim`](https://github.com/kiyoon/telescope-insert-path.nvim)                      | Insert selected path interactively (works in conjunction with other Telescope pickers)                         |
| [`nvim-telescope/telescope-ui-select.nvim`](https://github.com/nvim-telescope/telescope-ui-select.nvim) | Sets `vim.ui.select` to telescope. |

[Telescope]: https://github.com/nvim-telescope/telescope.nvim

### Plugins: Trees-itter
|Plugin name|Summary|
|-|-|
| [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) configs for different language parsers |
| [`theHamsta/crazy-node-movement`](https://github.com/theHamsta/crazy-node-movement) | nvim-treesitter module for navigation across AST (multiple languages) |
| [`nvim-treesitter/nvim-treesitter-textobjects`](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | nvim-treesitter module for custom textobjects |
| [`windwp/nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag) | nvim-treesitter module for html auto tag closing |


### Plugins: Themes
|Theme plugin name|Summary|
|-|-|
| [`shaunsingh/nord.nvim`](https://github.com/shaunsingh/nord.nvim)               | Theme   |
| [`marko-cerovac/material.nvim`](https://github.com/marko-cerovac/material.nvim) | Theme   |
| [`Mofiqul/vscode.nvim`](https://github.com/Mofiqul/vscode.nvim)                 | VS Code like theme |
| [`AlexvZyl/nordic.nvim`](https://github.com/AlexvZyl/nordic.nvim)               | 🌒 Nord for Neovim, but warmer and darker. Supports a variety of plugins and other platforms |
| [`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim)             | Theme   |
| [`catppuccin`](https://github.com/catppuccin/nvim)                              | Theme   |
| [`catppuccin-frappe`](https://github.com/catppuccin/nvim)                       | Default |
| [`Yazeed1s/oh-lucy.nvim`](https://github.com/Yazeed1s/oh-lucy.nvim)             | Inspired by oh-lucy theme in vscodium, with few tweaks! |
| [`rebelot/kanagawa.nvim`](https://github.com/rebelot/kanagawa.nvim)             | Theme   |

### Plugins by Hinell
These plugins are written & maintained by me.

|Plugin name|Summary|
|-|-|
| [`hinell/move.nvim`](https://github.com/hinell/move.nvim)                | Move selected chunks of text or lines                          |
| [`hinell/tabs-history.nvim`](https://github.com/hinell/tabs-history.nvim)| Track history of close tabs and focuse the last one            |
| [`hinell/lsp-timeout.nvim`](https://github.com/hinell/lsp-timeout.nvim)  | Halt unused LSP servers & restart them on demand automatically |

## See also
* [LazyVim](https://github.com/LazyVim/starter), quick-start config; 321 lines only
* [@amaanq/nvim-config](https://github.com/amaanq/nvim-config), mostly based on LazyVim
* [@axieax/dotconfig/nvim](https://github.com/axieax/dotconfig/), well organized configuration; 6321 lines
* [@danielnehrig/nvim](https://github.com/danielnehrig/nvim), monumental config; 9230 lines
* [@antgubarev/nvim](https://github.com/antgubarev/dotfiles/tree/master/nvim), minor; 1052 lines

------
> February  1, 2023</br>
> September 28, 2023

