-- TODO: [December 29, 2023] Add module description
local M = {}
M.init = function(self, pm)
	local use = pm.use
	use({
		"hinell/nvim-api.nvim",
		description = "Lua classes to abstract basic Neovim Lua API functions",
		-- config = function()
		-- 	local module = require("hinell/nvim-api.nvim")
		-- 	local legendaryIsOk, legendary = pcall(require, "legendary")
		-- 	if legendaryIsOk then
		-- 		local keymaps = {
		-- 			{}
		-- 		}
		-- 		legendary.keymaps(keymaps)
		-- 	end
		-- end
	})

end
return M
