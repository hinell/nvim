-- @module hinell-themes
-- M
-- Local UI & Colorscheme config
local M = {}

M.init = function(self, pm)

	local use = pm.use
	-- use({
	-- 	"shaunsingh/nord.nvim",
	-- 	lazy = true
	-- })
	--
	use({
		"marko-cerovac/material.nvim",
		lazy = true,
		config = require("hinell.plugins.themes.material").init
	})
	--
	use({
		"catppuccin/nvim",
		description = "Soothing pastel theme for (Neo)vim",
		name = "catppuccin",
		lazy = false,
		priority = 999,
		config = require("hinell.plugins.themes.catppuccin")
	})
	-- use({
	-- 	"AlexvZyl/nordic.nvim",
	-- 	lazy = true
	-- })
	-- use({
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = true
	-- })
	-- use({
	-- 	"rose-pine/neovim",
	-- 	lazy = true
	-- })
	-- use({
	-- 	"Yazeed1s/oh-lucy.nvim",
	-- 	lazy = true
	-- })
	-- use({
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = true
	-- })
	--

	-- use({
	-- 	"Mofiqul/vscode.nvim",
	-- 	lazy = true,
	-- 	config = require("hinell.plugins.themes.vscode").init
	-- })
	--
	-- use({
	-- 	"roobert/palette.nvim",
	-- 	priority = 1000,
	-- 	enabled = false,
	-- 	config = function()
	-- 		require("palette").setup({
	-- 			palettes = {
	-- 				-- dark or light
	-- 				main = "dark",
	--
	-- 				-- pastel, bright or dark
	-- 				accent = "dark",
	-- 				state = "pastel",
	-- 			},
	--
	-- 			italics = true,
	-- 			transparent_background = false,
	-- 		})
	-- 	end
	--
	-- })

	-- use({
	-- 	"bartekprtc/gruv-vsassist.nvim",
	-- 	priority = 1000,
	-- 	enabled = true,
	-- 	config = function()
	-- 		-- local config = {}
	-- 		-- config.italic_comments = false
	-- 		-- config.disable_nvimtree_bg = true
	-- 		-- require("gruv-vsassist").setup(config)
	-- 	end
	--
	-- })
	-- use({
	--   "jesseleite/nvim-noirbuddy",
	-- 	requires = {
	-- 		"tjdevries/colorbuddy.nvim",
	-- 		branch = "dev",
	-- 	},
	-- 	config = function()
	-- 	end
	-- })

	-- use({
	-- 	"projekt0n/github-nvim-theme",
	-- 	enabled = true,
	-- 	lazy = true,
	-- 	-- config = function()
	-- 	-- 	local palettes = {
	-- 	-- 		all = {
	-- 	-- 			blue = "#ffaa00"
	-- 	-- 		},
	-- 	-- 		github_dark = {
	-- 	-- 			blue = "#ffaa00"
	-- 	-- 		}
	-- 	-- 	}
	-- 	--
	-- 	-- 	require('github-theme').setup({ palettes = palettes })
	-- 	-- end
	-- })

end

return M
