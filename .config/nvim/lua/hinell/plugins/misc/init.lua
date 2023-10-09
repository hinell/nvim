-- M
-- Miscelanious plugins config
local M = {}

M.init = function(self, pm)
	local use = pm.use
	use({
		disable = false,
		"ellisonleao/carbon-now.nvim"
		, config = function()

			require("carbon-now").setup({
				drop_shadow = true,
				theme = "synthwave-84",
				titlebar = ""
			})

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				legendary.func({
					description = "Editor: selection: publish snippet code (carbon.sh.now)",
					vim.cmd.CarbonNow
				})
			end

		end
	})

	require("hinell.plugins.misc.bigfile"):init(pm)

end

return M
