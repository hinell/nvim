-- @module M
-- M
-- hinell-tree-sitter-autotag closing module for nvim-treesitter
local M = {}

M.init = function(self, packer)
	local use = packer.use
	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-treesitter.configs").setup({
				aliases = {
					markdown = "html"
				},
			  autotag = {
				enable = true
			  }
			})
		end
	})
end
return M
