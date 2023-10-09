-- TODO: [January 05, 2024] Add module description
local M = {}
M.init = function(self, pm)
	local use = pm.use
	use({
		"linrongbin16/lsp-progress.nvim",
		config = function()
			local lspProgress = require("lsp-progress")
			lspProgress.setup()
		end
	})

end
return M
