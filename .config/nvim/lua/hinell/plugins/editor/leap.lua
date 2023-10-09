--- @module 'hinell.plugins.editor.leap'
-- leap.nvim config
local M = {}
M.init = function(self, pm)
	local use = pm.use
	-- See also:
	-- https://github.com/folke/flash.nvim
	-- https://github.com/phaazon/hop.nvim
	use({
		disable = false,
		"ggandor/leap.nvim",
		description = "Jump by keystrokes to words within editor / windows",
		category = "ui",
		config = function()
			-- TODO: [November 16, 2023] Add lualine integration
			local leap = require("leap")
			-- require("leap").add_default_mappings()

			-- leap.add_repeat_mappings(";", ",", {
			-- 	relative_directions = true,
			-- 	-- modes = {"n", "x", "o"},
			-- })

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function ()
					vim.cmd("highlight! link LeapMatch Search")
					vim.cmd("highlight! link LeapLabelPrimary MatchParen")
					vim.cmd("highlight! link LeapLabelSecondary CurSearch")
				end
			})

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local keymaps = {
					{
						mode = { "n" }, "<C-S-Space>", description = "Editor: navigation: backward leap to a char", function()
							leap.leap({ backward = true })
						end
					},
					{
						mode = { "n" }, "<C-Space>", description = "Editor: navigation: forward leap to a char", function()
							leap.leap({ backward = false })
						end
					},
					{
						mode = { "n" }, "<C-W><C-Space>", description = "Window: navigation: forward leap to a char in next window", function()
							leap.leap({ target_windows = require('leap.util').get_enterable_windows() })
						end
					},
				}
				legendary.keymaps(keymaps)
			end

		end

	})

end
return M
