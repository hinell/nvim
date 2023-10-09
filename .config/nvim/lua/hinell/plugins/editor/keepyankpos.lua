-- Summary.....: This is a small 'plugin' keeps cursor from moving after yanking!
-- Created.....: March 23, 2025
-- Authors.....: Alex A. Davronov <al.neodim@gmail.com> (2025-)
-- Description.: Keep cursor position after yanking. Inspired by post gh-liu@github.com
-- at https://github.com/neovim/neovim/issues/12374#issuecomment-2121867087
-- Usage.......: Put into ~/.config/nvim/subdirectory and import it into init.lua


-- TODO: [March 23, 2025] Move to a separate plugin
-- CONTINUE: [April 20, 2025] Use "vim.on_key" ?
local M = {}

M.init = function(self, pm)
	local api = vim.api
	local autocmd = api.nvim_create_autocmd
	local augroup = api.nvim_create_augroup

	local g = augroup("UserKeepPostYankPos", {})

	autocmd("CursorMoved", {
		group = g,
		callback = function(e)
			local last_pos = vim.api.nvim_win_get_cursor(0)
			vim.b.user_yank_last_pos = last_pos
		end,
	})

	autocmd("TextYankPost", {
		group = g,
		callback = function(e)
			local last_pos = vim.b.user_yank_last_pos
			if last_pos and vim.v.event.operator == "y" then
				vim.api.nvim_win_set_cursor(0, last_pos)
			end
		end,
	})

	autocmd("BufEnter", {
		group = g,
		callback = function(e)
			vim.b.user_yank_last_pos = { 1, 1 }
		end,
	})

end

return M
