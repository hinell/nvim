-- Check current OS
if not jit.os == "Linux" then
	vim.notify(("%s: Only Linux systems are supported. Aborting.")
		:format(debug.getinfo(1).source), vim.log.levels.ERROR)
	return
end

if vim.fn.has("nvim-0.9") == 0 then
	vim.notify(("%s: Hinell neovim config requires Neovim version >= 0.9")
		:format(debug.getinfo(1).source), vim.log.levels.ERROR)
	return
end

local bootstrap = require("hinell.bootstrap")
	  bootstrap.fonts:has("JetBrainsMono Nerd Font Mono")

  -- Boostrapping packer
local packerOk, packer = pcall(require, "packer")
if not packerOk then
	vim.notify(("%s: trying to install packer.nvim")
		:format(debug.getinfo(1).source), vim.log.levels.DEBUG)

	bootstrap.packer:install()
	packerOk, packer = pcall(require, "packer")
	if not packerOk then
		local packerFailureMsg = "packer module has failed to install or not found!"
		error(("%s: %s"):format(debug.getinfo(1).source, packerFailureMsg))
		error(packer)
	end

end

-- TODO: [October 06, 2023] Packer in unmaintained; replace by lazy.nvim!
-- Boostrapping lazy.nvim
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local lazyIsOk, lazy = pcall(require, "lazy")
if not lazyIsOk  then
	vim.notify(("%s: trying to install lazy.nvim")
		:format(debug.getinfo(1).source), vim.log.levels.DEBUG)

	bootstrap.lazy.install()
	lazyIsOk, lazy = assert(pcall(require, "lazy"))
	if not lazyIsOk  then
		local failMsg = "can't load lazy module; install probably failed!"
		error(("%s: %s"):format(debug.getinfo(1).source, failMsg))
	end
end

-- Call this function before packer.startup()!
packer.init(require("hinell.plugins.packer").packer.config)
packer.reset()

------------------------------------------------------------------ui-colorscheme
-- vim.g.material_style = "darker"
-- vim.cmd.colorschem "material"
-- vim.cmd.colorscheme "vscode"
-- vim.cmd.colorscheme "tokyonight"
vim.cmd.colorscheme "catppuccin-macchiato"	-- Darker theme
-- vim.cmd.colorscheme "catppuccin-frappe"		-- Mid dark scheme

require("hinell.std")
require("hinell.options")
require("hinell.filetypes")
require("hinell.plugins.tabula")
require("hinell.nvim-keymaps"):init()

packer.startup(function(use)
	-- NOTE: [October 05, 2023] Do not call these inside ui/init.lua
	require("hinell.plugins.ui.legendary").packer:register(packer)
	require("hinell.plugins.ui.telescope").packer:register(packer)

	require("hinell.plugins.web-dev-icons").packer:register(packer)
	require("hinell.plugins.themes").packer:register(packer)
	require("hinell.plugins.editor").packer:register(packer)

	require("hinell.plugins.ui").packer:register(packer)
	require("hinell.plugins.lsp").packer:register(packer)
	require("hinell.plugins.git").packer:register(packer)

	-- These should be initialized before anything else
	local	legendaryOk ,legendary = pcall(require, "legendary")
	local	telescopOk  ,telescope = pcall(require, "telescope")
	local	masonOk     ,mason     = pcall(require, "mason")

	if masonOk then
		require("hinell.plugins.mason"):init(packer)
	end

	if	legendaryOk and
		telescopOk
	then
		require("hinell.plugins.snippets"):init(packer, legendary)
		require("hinell.plugins.utils"):init(packer, legendary)
		require("hinell.plugins.lsp").legendary:init(legendary, telescope)
		require("hinell.plugins.ui").legendary:init(legendary)
		require("hinell.plugins.ui.legendary"):init(legendary)
		require("hinell.plugins.ui.telescope"):init(legendary)
		require("hinell.plugins.git").legendary:init(legendary)

	else
		local msg = " legendary or telescope module is not found,"
		..	"functions and autocmds are NOT enabled, only shortcuts!"
		print(("%s: %s"):format(debug.getinfo(1).source, msg))
		if type(legendary)	== "string" then error(legendary) end
		if type(telescope)	== "string" then error(telescope) end
	end

end)

-- require("lazy").setup()

