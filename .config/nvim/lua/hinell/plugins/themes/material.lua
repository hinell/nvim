-- @module M
-- M
-- Material theme config
local M = {}

M.init = function()
	local material        = require("material")
		  material.colors = require("material.colors")
	require("material").setup({
		contrast = {
			terminal = false,
			sidebars = true,
            cursor_line = false,
            popup_menu = false,
			floating_windows = false
		},
		-- TODO: [April 27, 2023] Uncomment the plugins that are installed
		plugins = {
			-- "dap",
			-- "dashboard",
			"gitsigns",
			-- "hop",
			"indent-blankline",
			-- "lspsaga",
			-- "mini",
			"neogit",
			"nvim-cmp",
			"nvim-navic",
			"nvim-tree",
			"nvim-web-devicons",
			-- "sneak",
			"telescope",
			"trouble",
			-- "which-key",
		},
		high_visibility = {
			lighter = false, -- Enable higher contrast text for lighter style
			darker = false -- Enable higher contrast text for darker style
		},
		custom_colors = function(colors)
			-- colors.editor.fg        = "#B0BEC5"
			-- colors.editor.fg_dark   = "#8C8B8B"
		end,
		custom_highlights = {
			Folded = { fg = material.colors.main.white, bg = material.colors.main.grey },
			Function = { fg = material.colors.main.orange, italic = true },
			-- TelescopePromptBorder = { fg = "#0A0A0A", bg = "#000000", bold = true }
		}
	})
end -- END material theme setu

return M
