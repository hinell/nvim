<h1 align="center">HINELL / nvim</h1>

<div align="center">
<a href="preview.png" ><img height="127" src="preview.png" /></a>
<a href="./doc/preview-2.png" ><img height="127" src="doc/preview-2.png" /></a>
<a href="./doc/preview-3.png" ><img height="127" src="doc/preview-3.png" /></a>
<a href="./doc/preview-4.png" ><img height="127" src="doc/preview-4.png" /></a>
<a href="./doc/preview-5.png" ><img height="127" src="doc/preview-5.png" /></a>
</div>

[![PayPal](https://img.shields.io/badge/-PayPal-880088?style=flat-square&logo=pay&logoColor=white&label=DONATE)](https://www.paypal.me/biteofpie)

## Install


### Install prerequisites
As of August, 2023 [packer] plugin manager is unmaintained.</br>
This config uses [lazy.nvim] instead to manage & install plugins.</br>
It's auto-bootstrapped if not found. Stand-alone tools must must be installed separately.

#### Clibpoard
Nvim doesn't provide builtin clipboard support so you have to install clipboard provider. I suggest to use `xclip`.

#### Searching
**[ripgrep](https://github.com/BurntSushi/ripgrep#installation)** - This one is heavily used by [Telescope]

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

Use `williamboman/mason.nvim` to install LSP servers & other tools quickly.
See [lsp-config/server_configurations.md] for full list of LSP servers
Every LSP serever listed below requries a separate installation of the binary or script.
Check out `setup.sh` executable next to this file.

| LSP name | Languages | Summary |
|-|-|-|
|  [clangd][lsp-config-clangd] | c/c++ | |
| luals | lua   | |
| [bashls](https://github.com/bash-lsp/bash-language-server) | sh,bash,zsh   | Basic shell LSP server; quirky when works with `zsh` |
| [mattn/efm-languageserver](https://github.com/mattn/efm-langserver)  | * | General purpose server; see configs at [creativenull/efmls-configs-nvim](https://github.com/creativenull/efmls-configs-nvim) |
| [tsserver](https://github.com/typescript-language-server/typescript-language-server) | javascript, typescript | TypeScript server from Micro$$oft; pretty slow |
| [vscode-langservers-extracted] | json  | Requires [Node.js] installation; checkout `nvm` manager for `*nix` platforms|
| [vscode-langservers-extracted] | css, scss, less | Requires [Node.js]; use `npm` to install |
| [vscode-langservers-extracted] | html | Requires [Node.js]; use `npm` to install |
| [sqlls](https://github.com/joe-re/sql-language-server)             | sql    | Requires [Node.js]; use `npm` to install |
| [yamlls](https://github.com/redhat-developer/yaml-language-server) | yamlls | Requires [Node.js]; use `npm` to install |

[vscode-langservers-extracted]: (https://github.com/hrsh7th/vscode-langservers-extracted) "vscode-langservers bin collection"

### Usage
```vim
" ~/.config/nvim/init.vim
lua require("hinell")
```
## DOCUMENTATION
* **[Plugins](.config/nvim/doc/plugins.md)** - List of plugins used
* **[Plugins/Hinel](.config/nvim/doc/plugins-hinell.md)** - List of built-in plugins 
* **[Keymaps](.config/nvim/doc/keymaps.md)** - List of keybindings (not exhaustive)

### Troubleshooting
Run `:checkhealth` command to see if something wrong with your installation.

[lsp-config-clangd]: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
[lsp-config/server_configurations.md]: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md 'LSP Config Server Configurations list'
[packer]: https://github.com/wbthomason/packer.nvim
[lazy.nvim]: https://github.com/folke/lazy.nvim
[Node.js]: https://github.com/nodejs/node

## SEE ALSO 
* [LazyVim](https://github.com/LazyVim/starter), quick-start config; 321 lines only
* [nvim-lug/kickstart](https://github.com/nvim-lua/kickstart.nvim), quick-start config (?)
* [@amaanq/nvim-config](https://github.com/amaanq/nvim-config), mostly based on LazyVim
* [@axieax/dotconfig/nvim](https://github.com/axieax/dotconfig/), well organized configuration; 6321 lines
* [alpha2phi/modern-neovim/tree/19-plugins-3](https://github.com/alpha2phi/modern-neovim/tree/19-plugins-3) - modernized config; 7925 lines)
* [@danielnehrig/nvim](https://github.com/danielnehrig/nvim), monumental config; 9230 lines
* [@akinsho/nvim](https://github.com/akinsho/dotfiles/tree/main/.config/nvim)
* [@antgubarev/nvim](https://github.com/antgubarev/dotfiles/tree/master/nvim), minor; 1052 lines
* [@wbthomason/nvim](https://github.com/wbthomason/dotfiles/tree/linux/neovim/.config/nvim)
* [@verdverm/neoverm](https://github.com/verdverm/neoverm/tree/main)
* [@mhinz/vim-startify](https://github.com/mhinz/vim-startify)
* [@wuelnerdotexe/nvim](https://github.com/wuelnerdotexe/nvim)
* [@tomaskallup/nvim](https://github.com/tomaskallup/dotfiles/tree/master/nvim/lua)
* [@ibhagwan/nvim](https://github.com/ibhagwan/nvim-lua)
* [@ibhagwan/anuvyklack/dotfiles](anuvyklack/dotfiles/tree/main/roles/neovim/files) - a bit outdated (?, Dec 2022) 

------
> February  1, 2023
> November 16, 2023

