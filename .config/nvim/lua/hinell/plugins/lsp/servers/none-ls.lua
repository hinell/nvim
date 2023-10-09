--- @module none-ls-config
-- none-ls (null-ls previously) configuration
local M = {}
M.init = function(self, pm)
	local use = pm.use
	use({
		"nvimtools/none-ls.nvim",
		config = function()
			local none_ls = require("null-ls")
			none_ls.setup({
				sources = {
					none_ls.builtins.diagnostics.eslint_d
				},
			})
			-- local legendaryIsOk, legendary = pcall(require, "legendary")
			-- if legendaryIsOk then
			-- 	local keymaps = {
			-- 		{}
			-- 	}
			-- 	legendary.keymaps(keymaps)
			-- end
		end
	})

end
return M
