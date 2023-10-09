--- @module hinell-git
--- git related plugins config
local M = {}

M.init = function(self, pm)
	local use = pm.use
	-- Workspace scuffold helper to generate gigignore
	use({
		"wintermute-cell/gitignore.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			local gitignore = require("gitignore")
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local functions = {
					{ description = "Workspace: scaffold: .gitignore", gitignore.generate }
				}
				legendary.funcs(functions)
			end
		end
	})

	require("hinell.plugins.git.diffview").packer:register(pm)
	require("hinell.plugins.git.gitsigns").packer:register(pm)
	require("hinell.plugins.git.gitlinker"):init(pm)
end

return M
