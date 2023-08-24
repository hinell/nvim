-- @module M
-- M
-- Lualine config
local M = {}
M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	-- Bottom statusline
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = false },
		config = function()
			local lualine = require("lualine")
			lualine.setup({
				theme = "auto",
				extensions = {
					"fzf", "man", "nvim-tree"
				},
				sections = {
					lualine_b = {
							"b:gitsigns_status", "branch", "diff",
						{
							"diagnostics",
							-- sources = { "nvim_diagnostic" },
							-- symbols = {error = "E ", warn = "W ", info = "I ", hint = "H "}
							-- symbols = { error = " ", warn = " ", info = " ", hint = " " },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
						}
					},
					lualine_x = { "encoding", "fileformat", "filetype" }
				}
			})
		end
	})
end
return M

