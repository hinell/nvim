--- @module vim-matchup
-- M
-- Plugin for % hotkey
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	use({
		"andymass/vim-matchup",
		setup = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				matchup = {
					enable = true,              -- mandatory, false will disable the whole extension
					-- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
				}
			})
		end
	})
end

return M
