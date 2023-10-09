--- @module gitlinker
-- M
-- gitlnker config
local M = {}
M.legendary = {}
M.legendary.funcs = {
	{
		description = "Workspace: buffer: clipboard: copy permalink to git repo (git linker)",
		function()
			local mode = vim.api.nvim_get_mode().mode
			if mode == "v" or mode == "V" or mode == "n" then
				require("gitlinker").link()
			end
		end

	}
}
M.init = function(self, pm)
	local use = pm.use
	use({
		"linrongbin16/gitlinker.nvim",
		config = function()
			require("gitlinker").setup()
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				legendary.funcs(M.legendary.funcs)
			end
		end,
		mappings = nil
	})

end
return M
