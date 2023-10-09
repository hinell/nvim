-- hlchunk is for drawing indent column lines on the left
-- Vertical lines hilghlighting scope of the current
local M = {}
M.init = function(self, pm)
	local use = pm.use
	use({
		-- "hinell/hlchunk.nvim",
		"shellRaining/hlchunk.nvim",
		description = "Highlight current scope and show indent lines.",
		enabled = true,
		-- branch = "chunk-mod-left-arrow",
		category = "ui",
		event = {"UIEnter"},
		config = function()

			local hlchunk = require("hlchunk")
			local exclude_filetypes = require("hlchunk.utils.filetype").exclude_filetypes
			if type(exclude_filetypes) ~= "table" then
				vim.notify_once(
					"hinell.ui: hlchunk failed to load .exclude_filetypes, api has probably changed!",
					vim.log.levels.WARN)
			end
			exclude_filetypes.help = true
			exclude_filetypes.zsh = false
			exclude_filetypes.bash = false

			local config = {}
			config.indent = {}
			config.indent.enable = true
			config.indent.use_treesitter = false
			config.indent.chars = {"│", "¦", "┆", "┊"}
			config.chunk = {}
			config.chunk.enable = true
			config.chunk.max_file_size  = 3145728 -- (1024 * 3072
			config.chunk.use_treesitter = true
			config.chunk.exclude_filetypes = exclude_filetypes
			config.chunk.chars = {}
			-- config.chunk.chars.left_arrow      = ">"
			-- config.chunk.chars.left_arrow      = "╼"
			-- config.chunk.chars.left_arrow      = "⯈"
			-- config.chunk.chars.left_arrow      = "〉"
			config.chunk.chars.left_arrow = "•"
			config.chunk.chars.left_arrow = "🤆"
			config.chunk.chars.left_arrow = "🢖"
			config.chunk.chars.horizontal_line = "─"
			config.chunk.chars.vertical_line = "│"
			-- config.chunk.chars.left_top        = "╭"
			-- config.chunk.chars.left_bottom     = "╰"
			config.chunk.chars.left_top = "┌"
			config.chunk.chars.left_bottom = "└"
			-- config.chunk.chars.right_arrow     = ">"
			-- config.chunk.chars.right_arrow     = "╼"
			-- config.chunk.chars.right_arrow     = "⯈"
			-- config.chunk.chars.right_arrow     = "〉"
			config.chunk.chars.right_arrow = "•"
			config.chunk.chars.right_arrow = "🤆"
			config.chunk.chars.right_arrow = "🢖"
			config.chunk.style = {{fg = "#806d9c"}, {fg = "#8f3131"}}

			config.line_num = {}
			config.line_num.enable = true
			config.line_num.notify = true
			config.line_num.use_treesitter = false
			-- config.line_num.style = "#806d9c"
			config.line_num.exclude_filetypes = exclude_filetypes

			local theme_scope_hl_ok = vim.api.nvim_get_hl(0, {
				name = "@Comment",
				link = false
			}).fg
			local theme_scope_hl_er = vim.api.nvim_get_hl(0, {
				name = "@Error",
				link = false
			}).fg
			local theme_brighten_const = 0xA0A0A
			-- Brighten up values a bit
			local bit = require("bit")
			if theme_scope_hl_ok ~= nil then
				--- @diagnostic disable-next-line: assign-type-mismatch
				config.chunk.style[1].fg = bit.bor(theme_scope_hl_ok, theme_brighten_const)
				config.line_num.style = vim.fn.printf("#%x",
				                                      bit.bor(theme_scope_hl_ok, 0x7F3300))
			end
			if theme_scope_hl_er ~= nil then
				--- @diagnostic disable-next-line: assign-type-mismatch
				config.chunk.style[2].fg = bit.bor(theme_scope_hl_er, theme_brighten_const)
			end

			hlchunk.setup(config)
		end
	})
end

return M
