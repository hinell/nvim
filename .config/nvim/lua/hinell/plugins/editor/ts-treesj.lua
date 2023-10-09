-- treesj configuration
local M = {}
M.init = function(self, pm)
	local use = pm.use
	use({
		"Wansmer/treesj",
		-- cmd = {"TSJToggle", "TSJSplit", "TSJJoin"},
		dependencies = {"nvim-treesitter/nvim-treesitter"},
		config = function()
			local treesj = require("treesj")
			treesj.setup({
				use_default_keymaps = false
			})
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local funcs = {
					{ description = "Editor: AST: node: wrap (treesj)", treesj.join },
					{ description = "Editor: AST: node: unwrap (treesj)", treesj.split },
					{ description = "Editor: AST: node: toggle wrapt/unwrap (treesj)", treesj.toggle }
				}
				legendary.funcs(funcs)
			end
		end
	})
end
return M
