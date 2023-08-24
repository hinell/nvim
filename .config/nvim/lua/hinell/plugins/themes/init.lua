-- @module M
-- M
-- Local UI & Colorscheme config
local M = {}

M.packer = {}
M.packer.register = function(self, packer)

	local use = packer.use

	use({
		"NvChad/nvim-colorizer.lua",
		config = function() require("colorizer").setup({}) end
	})
	use("shaunsingh/nord.nvim")

	use({
		"marko-cerovac/material.nvim",
		config = require("hinell.plugins.themes.material").init
	})

	use({
		"catppuccin/nvim",
		config = require("hinell.plugins.themes.catppuccin")
	})
	use({"AlexvZyl/nordic.nvim"})
	use({"folke/tokyonight.nvim"})
	use({"rose-pine/neovim"})
	use({"Yazeed1s/oh-lucy.nvim"})
	use({"rebelot/kanagawa.nvim"})
	use({"j-hui/fidget.nvim"})

	use({
		"Mofiqul/vscode.nvim",
		config = require("hinell.plugins.themes.vscode").init
	})

end

return M
