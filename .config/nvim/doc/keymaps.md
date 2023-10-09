# Keymaps

Most of features that can be invoked via hotkeys are rarely needed,
this config keeps most of them behind `Legendary.nvim` configurations: in command palette/pane.
Everyday keymaps however are bound directly to keystrokes/hotkeys.

For a partial list of keymaps, see
[`nvim-keymaps.lua`](../lua/hinell/nvim-keymaps.lua) file.

Plugin-specific keybings may be found in the `plugin/*/*.lua` files.

### Escape
Most of the time, <kbd>ESC</kbd> will return you to normal mode, or stop current action.

### Keymaps: Files navigation

| Mode | Keymap | Description |
|-|-|-|
| n |  <kbd>CTRL+SHIFT+P</kbd> | Open command palette |
| n |  <kbd>CTRL+O CTRL+O</kbd> | Open file (Telescope) |
| n |  <kbd>CTRL+O CTRL+R</kbd> | Open recent file (Telescope) |
| n |  <kbd>CTRL+O CTRL+F</kbd> | Open file with a given string/search in file (Telescope) |
| n |  <kbd>ALT+1</kbd> | Open nvim-tree pane to the right |

<!-- | * | <kbd>CTRL+0</kbd> | Focus tab N specified via input (shows total number of tabs) | -->
### Keymaps: Tabs navigation
| Mode | Keymap | Description |
|-|-|-|
| * | <kbd>CTRL+P</kbd> | Switch to an opened file (Telescope) |
| * | <kbd>CTRL+P CTRL+B</kbd> | Switch buffer (Telescope) |
| * | <kbd>CTRL+P CTRL+T</kbd> | Switch tabs (Telescope) |
| * | <kbd>CTRL+1</kbd>...<kbd>CTRL+N</kbd> | Focus tab N |
| * | <kbd>CTRL+SHIFT+LEFT</kbd>  | Move tab leftward on a tab pane |
| * | <kbd>CTRL+SHIFT+RIGHT</kbd> | Move tab rightward on a tab pane |

### Keymaps: Editor navigation
| Mode | Keymap | Description |
|-|-|-|
| ni | <kbd>CTRL+UP</kbd>   | Scroll editor UP |
| ni | <kbd>CTRL+DOWN</kbd> | Scroll editor UP |

### Keymaps: Edits  navigation
| Mode | Keymap | Description |
|-|-|-|
| * | <kbd>ALT+LEFT</kbd> | Jumpt to previous jump place (see also `h @;`) |
| * | <kbd>ALT+RIGHT</kbd> | Jumpt to next jump place |
| * | <kbd>[c</kbd> | Jumpt to previous change (git) |
| * | <kbd>c]</kbd> | Jumpt to next change (git) |

### Keymaps: Editing
| Mode | Keymap | Description |
|-|-|-|
| i | <kbd>CTRL+SPACE</kbd> | Open completion dropdown (nvim-cmp) |
| i | <kbd>CTRL+C</kbd> | Abort snippet completion |
| iv | <kbd>CTRL+SHIFT+UP/DOWN</kbd> | Duplicate line/selection Up/Down (see also `h duplicate.txt`) |

### Keymaps: AST navigation
These bindings are powered by tree-sitter plugins; see related config lua files

| Mode | Keymap | Description |
|-|-|-|
| nv | <kbd>ALT+j</kbd> | Ast: highlight (n) or select (v) & jump to the parent node |
| nv | <kbd>ALT+k</kbd> | Ast: highlight (n) or select (v) & jump to the child node |
| nv | <kbd>ALT+l</kbd> | Ast: highlight (n) or select (v) & jump to the right node |
| nv | <kbd>ALT+h</kbd> | Ast: highlight (n) or select (v) & jump to the left node |

### Keymaps: within Telescope windows
See also [Telescope.nvim default mapping](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#default-mappings) 

| Mode | Keymap | Description |
|-|-|-|
| n | <kbd>["p."]</kbd>| Paste selected entry's file name into current buffer. Works only with paths! |
| n | <kbd>["p="]</kbd>| Paste selected entry's file path into current buffer. Works only with paths! |

### NOTES
**NVIM MODES:** 
* n - normal
* i - insert
* v - visual
* o - pending
* \* - any

------
> October 13, 2023
> October 11, 2023
