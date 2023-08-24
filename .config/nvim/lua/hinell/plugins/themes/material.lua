-- @module M
-- M
-- Material theme config
local M = {}

M.init = function()
	if ok then
		local colors = require("material.colors")
		require("material").setup({
			contrast = {
				terminal = false,
				sidebars = false,
				floating_windows = true
			},
			-- TODO: [April 27, 2023] Uncomment the plugins that are installed
			plugins = {
				-- "dap",
				-- "dashboard",
				-- "gitsigns",
				-- "hop",
				"indent-blankline",
				-- "lspsaga",
				-- "mini",
				-- "neogit",
				"nvim-cmp",
				-- "nvim-navic",
				"nvim-tree",
				"nvim-web-devicons",
				-- "sneak",
				"telescope",
				-- "trouble",
				-- "which-key",
			},
			high_visibility = {
				lighter = false, -- Enable higher contrast text for lighter style
				darker = false -- Enable higher contrast text for darker style
			},
			custom_highlights = {
				Folded = { fg = colors.main.darkgreen, bg = colors.main.grey }
			}
		})
	end -- END material theme setu
end

return M
