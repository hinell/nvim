local M = {}

M.init = function(self, pm)
	local use = pm.use
	-- Workspace scuffold helper to generate gigignore
	-- Load this plugin only on request
	vim.g.loaded_gitignore = true
	vim.g.gitignore_nvim_overwrite = false
	use({
		"https://github.com/wintermute-cell/gitignore.nvim",
		description = "Plugin for generating .gitignore files",
		lazy = true,
		dependencies = {
			"nvim-telescope/telescope.nvim"
		},
		init = function()
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local functions = {
					{
						description = "Workspace: scaffold: .gitignore", function()
							require("gitignore").generate({ bang = true })
						end
					}
				}
				legendary.funcs(functions)
			end
		end,
		-- config = function()
		-- end
	})

	require("hinell.plugins.git.diffview"):init(pm)
	require("hinell.plugins.git.gitsigns"):init(pm)
	require("hinell.plugins.git.gitlinker"):init(pm)
end

return M
