local opt       = vim.opt
opt.clipboard   = "unnamed,unnamedplus"
opt.undofile    = true
opt.undolevels  = 1024
opt.wrap        = false         -- Soft-wrapping
opt.smartindent = true
opt.linebreak   = true          -- Break on
opt.updatetime  = 512           -- Time to save (in ms.)
opt.whichwrap:append("<,>,[,]") -- Allo <Left>/<Right> to move across s
--- opt.virtualedit="all"
opt.exrc		= true			-- Execute .nvim.lua from pwd
opt.autowrite	= true			-- Execute .nvim.lua from pwd


------------------------------------------------------------------------------ui
opt.showtabline   = 1
opt.scrolloff     = 2			-- Border line number before which scroll activated
-- opt.colorcolumn   ="80,120" --- This one setup by UI plugin instead!
opt.splitright    = true
opt.cursorline    = true		-- highlight current line
opt.cursorcolumn  = false		-- highlight current column

--- See also: `h :behave`
--- opt.keymodel='startsel' -- Activate selection upton shift+arrow
--- opt.selection="exclusive"
opt.laststatus    = 3
--- opt.completeopt="menu,menuone,preview,noselect"
opt.completeopt   = "menu,menuone,preview,noselect"
--- opt.titlestring="%<%F%=%l/%L-%P"
--- opt.titlestring="%t%( %M%)%( (%{expand(\"%:~:.:h\")})%)%( %a%)"
--- opt.titlestring=" %{getcwd()} [ %t%( %M%)%( (%{expand(\"%:~:.:h\")})%)%( %a%) ]"
opt.title         = true
opt.titlestring   = "%{getcwd()} : %{expand(\"%:r\")} [%M] ― Neovim"
opt.titlelen      = 127

--- opt.winbar="%M"
--- opt.guicursor  -- This one should be in ginit
opt.switchbuf     = "usetab"
opt.termguicolors = true

opt.cmdwinheight  = 12



--------------------------------------------------------------------------buffer
--- opt.indent_blanking_char = ""
--- opt.hidden        = true
opt.bufhidden     = "unload"
opt.number        = true -- Left pane with numbers for code
opt.numberwidth   = 8
opt.signcolumn    = "auto:8"
-- This option is manipulated dynamically via autocmd
-- opt.relativenumber



-------------------------------------------------------------------------folding
---Do not fold when <ESC> from insert mode
opt.foldopen:append("insert")
opt.foldmethod     = "expr"
opt.foldlevel      = 0
opt.foldlevelstart = 1 -- 0 to close all folds upon opening file
opt.foldminlines   = 4
opt.foldcolumn     = "auto"
opt.foldenable     = true



-----------------------------------------------------------------------buffer-ui
opt.ruler          = true
opt.rulerformat    = ""

--- Control chars display characters
opt.list           = true
opt.listchars      = "tab:  ⇢,eol:↲,trail:•,nbsp:␣,conceal:⋯,space:⋅"
opt.lazyredraw     = true


-------------------------------------------------------------syntax-highlighting
opt.conceallevel   = 1
--- Convert <TAB> into <spaces>* upon insertion, indents etc.
--- Use the following comand to convert tabs to spaces or otherwise:
---		:set [no]expandtab
---		:%retab



----------------------------------------------------------------------tabs-chars
opt.expandtab      = false
opt.tabstop        = 4
opt.softtabstop    = 4
opt.shiftwidth     = 0
-- Map Russian chars into latin ones when in RU keyboard layout
opt.langmap        =  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;"
					.. "ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;"
				   	.. "abcdefghijklmnopqrstuvwxyz"


-------------------------------------------------------------------------session
--- Saves nvim options at the bottom of the file
opt.modeline       = true
opt.modelineexpr   = true
opt.ignorecase     = true

------------------------------------------------------------------------spelling
-- Toggle only locally

opt.spell     = false
opt.spelllang = "en_us"
opt.spellfile = "spell/en.utf-8.add"
