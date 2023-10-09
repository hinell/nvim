-- M
-- Miscelanious plugins config
local M = {}

M.init = function(self, pm)
	local use = pm.use
	use({
		enable = false,
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

	-- TODO: [March 20, 2025] Update when it starts to use :trust function
	-- https://github.com/klen/nvim-config-local
	-- use({
	-- 	enable = true,
	-- 	description = "Secure loading of local .nvim.lua files configs for neovim",
	-- 	"klen/nvim-config-local"
	-- 	, config = function()
	-- 		local cfg = {}
	-- 		cfg.config_files = { ".nvim.lua" }
	--
	-- 		require('config-local').setup(cfg)
	--
	-- 		local legendaryIsOk, legendary = pcall(require, "legendary")
	-- 		if legendaryIsOk then
	-- 			local funcs = {
	-- 				itemgroup = "Nvim",
	-- 				description = "exrc and .nvim.lua management commands",
	-- 				funcs = {
	-- 					{
	-- 						description = "Nvim: selection: publish snippet code (carbon.sh.now)",
	-- 						vim.cmd.ConfigEdit
	-- 					}
	-- 				}
	-- 			}
	-- 			legendary.funcs(funcs)
	--
	-- 		end
	--
	-- 	end
	-- })


end

return M
