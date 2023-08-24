-- @module hinell-config-base64
-- Base64 config
local M = {}
M.description = "Make arbitrary Lua functions that can be executed via the item finder"
M.init = function(self, packer, legendary)

	-- Encode/decode strings into/out of Base64
	local use = packer.use
	use({
		"taybart/b64.nvim",
		config = function()
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				local funcs = {
					{ description = "Line: Selection: base64 - encode", require("b64").encode }
				,	{ description = "Line: Selection: base64 - decode", require("b64").decode }
				}
				legendary.funcs(funcs)
			end
		end
	})

end
return M
