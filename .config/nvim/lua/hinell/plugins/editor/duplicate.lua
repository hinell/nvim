--- @module duplicate
-- M
-- hinell/duplicate.nvim config
local M = {}

M.init = function(self, packageManager)
	local use = packageManager.use
	use({
		"hinell/duplicate.nvim",
		config = function()

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local keymaps = {
					{
						description = "Editor: line: duplicate up",
						mode = {"i", "n"},
						"<C-S-A-Up>",
						"<CMD>LineDuplicate -1<CR>"
					}, {
						description = "Editor: line: duplicate down",
						mode = {"i", "n"},
						"<C-S-A-Down>",
						"<CMD>LineDuplicate +1<CR>"
					}, {
						description = "Editor: selection: duplicate up",
						mode = {"v"},
						"<C-S-A-Up>",
						"<CMD>VisualDuplicate -1<CR>"
		 			}, {
						description = "Editor: selection: duplicate down",
						mode = {"v"},
						"<C-S-A-Down>",
						"<CMD>VisualDuplicate +1<CR>"
					}
				}
				legendary.keymaps(keymaps)
			end

		end
	})
end

return M
