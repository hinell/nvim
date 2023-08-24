-- @module M
-- M
-- Vscode theme config
local M = {}

M.init = function()
	local ok, vscode = pcall(require, "vscode")
	assert(ok, "vscode module is not found")
	if ok then
		require("vscode").setup({
			-- Enable transparent background
			transparent = true,
			italic_comments = true,
			disable_nvimtree_bg = true,
			color_overrides = {
			},
			-- Override highlight groups (see ./lua/vscode/theme.lua)
			group_overrides = {
				-- this supports the same val table as vim.api.nvim_set_hl
				-- use colors from this colorscheme by requiring vscode.colors!
				-- Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
			}
		})
	end
end
return M
