-- @module utils
-- M
-- Various dev utils
local M = {}

M.init = function (self, packer)
	local use = packer.use

	-- Provides commands for scripts to generate doc/*.txt files from markdown
	use({
		"ibhagwan/ts-vimdoc.nvim"
	})

	use({
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		config = function()
			require("package-info").setup()
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if not legendaryIsOk then return end

			local augroup = vim.api.nvim_create_augroup
			local auclear = vim.api.nvim_clear_autocmds
			local autocmd = vim.api.nvim_create_autocmd
			local usercmd = vim.api.nvim_create_user_command

			augroup("UserPackageInfo", { clear = true })
			autocmd({
					"BufRead"
				},{
					pattern  = "package.json",
					once     = false,
					group    = "UserPackageInfo",
					callback = function(auEventBufRead)
						local bufnr        = auEventBufRead.buf
						local opts         = { buffer = bufnr }
						local legendary    = require("legendary")
						local package_info = require("package-info")
						legendary.funcs({
							{ description = "Editor: package.json: deps: toggle"  ,package_info.toggle  ,opts = opts },
							{ description = "Editor: package.json: deps: update"  ,package_info.update  ,opts = opts },
							{ description = "Editor: package.json: deps: install" ,package_info.install ,opts = opts },
							{ description = "Editor: package.json: deps: delete"  ,package_info.delete  ,opts = opts },
							{ description = "Editor: package.json: deps: modify"  ,package_info.change_version, opts = opts }
						})
					end
			})

			autocmd({
					"BufLeave"
				},{
					pattern  = "package.json",
					once     = false,
					group    = "UserPackageInfo",
					callback = function(auEventBufRead)
						local bufnr = auEventBufRead.buf
						auclear({ group = "UserPackageInfo" })
					end
			})

			autocmd({
					"BufUnload"
				},{
					pattern  = "package.json",
					once     = false,
					group    = "UserPackageInfo",
					callback = function(auEventBufRead)
						auclear({ group = "UserPackageInfo" })
					end
			})
			-- require("telescope").setup({
			-- 	extensions = {
			-- 		package_info = {
			-- 			-- Optional theme (the extension does not set a default theme)
			-- 			-- theme = "ivy"
			-- 		},
			-- 	},
			-- })
			-- require("telescope").load_extension("package_info")
		end
	})

	require("hinell.plugins.utils.markdown"):init(packer)
end

return M
