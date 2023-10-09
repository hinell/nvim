--- @module "lazy.types"

-- Check current OS, exit if not linux;
-- this may be commented out to proceed
if not jit.os == "Linux" then
	vim.notify(("%s: Only Linux systems are supported. Aborting.")
		:format(debug.getinfo(1).source), vim.log.levels.ERROR)
	return
end

if vim.fn.has("nvim-0.9") == 0 then
	vim.notify(("%s: Hinell neovim config requires Neovim version >= 0.9. Aborting.")
		:format(debug.getinfo(1).source), vim.log.levels.ERROR)
	return
else
	-- This uses new, faster loader; previously,
	-- ref: https://github.com/lewis6991/impatient.nvim
	-- compat: nvim v0.9.0
	vim.loader.enable()
end
-- Small bootstrapping script
local bootstrap = require("hinell.bootstrap")
	  bootstrap.fonts:has("JetBrainsMono Nerd Font Mono")

-- Boostrapping lazy.nvim
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local lazyIsOk, lazy = pcall(require, "lazy")
if not lazyIsOk  then
	vim.notify(("%s: trying to install lazy.nvim")
		:format(debug.getinfo(1).source), vim.log.levels.DEBUG)

	bootstrap.lazy.install()
	lazyIsOk, lazy = pcall(require, "lazy")
	if not lazyIsOk  then
		local failMsg = "can't load lazy module; installation has probably failed!"
		error(("%s: %s"):format(debug.getinfo(1).source, failMsg))
	end
end

lazy = require("hinell.lazy")
local plugins     = lazy.Plugins:new()

-- Previously, I've used packer.nvim, but it got archived and dropped; it provided
-- use() function to register plugins; this is a shim for that funcion
local pm = {}
--- @param pluginSpec LazyPluginSpec
pm.use = function(pluginSpec)
	plugins:use(pluginSpec, { warn = false })
end

-- Provides .use function that extends pluginSpecs with sensible description
-- that can be used for auto-generating readme for this collection of plugins
pm.extended = function(pluginSpecExt)
	pm.use = function(pluginSpec)
		pluginSpec = vim.tbl_extend("force", pluginSpecExt, pluginSpec)
		return plugins:use(pluginSpec, { warn = false })
	end
	return pm
end

-------------------------------------------------------------------------plugins

-- local std = require("std") -- Moved to init.lua
-- TODO: [December 12, 2023] Move to a separate plugin
-- require("profiler"):init({})

require("hinell.options")
-- require("hinell.filetype") -- preloaded via after/filetype.lua

require("hinell.plugins.ui.legendary"):init(pm.extended({ category = "ui", description = "n/a" }))
require("hinell.plugins.ui.telescope"):init(pm.extended({ category = "ui", description = "n/a" }))

require("hinell.plugins.themes"):init(pm.extended({ category = "theme", description = "n/a" }))
require("hinell.plugins.web-dev-icons"):init(pm.extended({ category = "ui", description = "n/a" }))

require("hinell.plugins.editor"):init(pm.extended({ category = "editor", description = "n/a" }))
require("hinell.plugins.ui"):init(pm.extended({ category = "ui", description = "n/a" }))
require("hinell.plugins.lsp"):init(pm.extended({ category = "lsp", description = "n/a" }))
require("hinell.plugins.git"):init(pm.extended({ category = "git", description = "n/a" }))
require("hinell.plugins.misc"):init(pm.extended({ category = "misc", description = "n/a" }))
require("hinell.plugins.nvim-api"):init(pm.extended({ category = "nvim", description = "nvim api related plugin" }))
require("hinell.plugins.utils"):init(pm.extended({ category = "utils", description = "n/a" }))
require("hinell.plugins.snippets"):init(pm.extended({ category = "snipets", description = "n/a" }))
require("hinell.plugins.mason"):init(pm.extended({ category = "dev-x", description = "n/a" }))


---------------------------------------------------------plugin-development-zone

pm.use({
	dir = "~/.local/share/nvim/lazy/oop-std.lua",
	lazy = true,
	enable = true,
	config = function()
		-- local std = loadfile(vim.fn.stdpath("data") .. "/lazy/oop-std.lua/lua/oop-std/init.lua")()
		local std = require("oop-std")
		end
})

if vim.env.PLUGINS_DEV then
	pm.use({
		dir = "~/.local/share/nvim/lazy/tabs-focus-previous.nvim",
		dependencies = {
			-- "hinell/nvim-api.nvim",
			-- "hinell/std-lua.nvim"
		},
		enable = true,
		config = function()
			local tfp = require("tabs-focus-previous")

			-- local legendaryIsOk, legendary = pcall(require, "legendary")
			-- if legendaryIsOk then
			-- 	local keymaps = {
			-- 	}
			-- 	legendary.keymaps(keymaps)
			-- end
		end
	})
end

-- loading plugins
require("lazy").setup(plugins, {
	git = {
		url_format = "git@github.com:%s.git"
	}
})

-- These should be initialized before anything else
local	legendaryOk ,legendary = pcall(require, "legendary")
local	telescopOk  ,telescope = pcall(require, "telescope")


-- require("hinell.plugins.tabula")
require("hinell.nvim-keymaps"):init()

if	not (legendaryOk or telescopOk)
then
	local msg = " legendary or telescope module is not found,"
	..	"functions and autocmds are NOT enabled, only shortcuts!"
	print(("%s: %s"):format(debug.getinfo(1).source, msg))
	-- if type(legendary)	== "string" then error(legendary) end
	-- if type(telescope)	== "string" then error(telescope) end
end


--------------------------------------------------------------------------------
-- See for a list of themes:
-- .config/nvim/lua/hinell/plugins/themes/init.lua
-- NOTE: If you are using packer.nvim, uncomment (this should load twice, yes)
-- NOTE: To get theme, go to the themes/init.lua and uncomment plugin

-- use direct configs for themes
-- vim.g.material_style = "darker"
-- vim.cmd.colorschem "material"
-- vim.cmd.colorschem "material"

-- vim.cmd.colorscheme "vscode"
-- vim.cmd.colorscheme "tokyonight"
vim.cmd.colorscheme "catppuccin-frappe"		-- Mid dark scheme
vim.cmd.colorscheme "catppuccin-frappe"		-- Mid dark scheme

-- vim.cmd.colorscheme "catppuccin-macchiato"	-- Darker theme
-- vim.cmd.colorscheme "catppuccin-macchiato"	-- Darker theme

-- vim.cmd.colorscheme "catppuccin-mocha"	-- Darker theme
-- vim.cmd.colorscheme "catppuccin-mocha"	-- Darker theme


-- See also: ui/telescope.lua
local isCatppuccinDarkTheme = not vim.g.colors_name	== "catappuccin-latte"
local isMaterialDarkTheme = vim.g.colors_name ~= "material"
	and vim.g.material_style ~= "lighter"
local isDarkTheme = isCatppuccinDarkTheme or isMaterialDarkTheme
if isDarkTheme then
	vim.cmd("hi Folded guifg=#eeeeee")
end
