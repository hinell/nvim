--- @module packer
--- packer.nvim config
local M = {}

M.packer = {}
M.packer.config = {
	git = {
		subcommands = {
			update = "pull --no-tags --ff-only --progress --rebase=false",
			install = "clone --no-tags --depth %i --no-single-branch --progress"
		}
	},
	display = {
		-- open_fn = require('packer.util').float,
		-- open_fn = function()
		--   local result, win, buf = require('packer.util').float {
		-- 	border = {
		-- 	  { '╭', 'FloatBorder' },
		-- 	  { '─', 'FloatBorder' },
		-- 	  { '╮', 'FloatBorder' },
		-- 	  { '│', 'FloatBorder' },
		-- 	  { '╯', 'FloatBorder' },
		-- 	  { '─', 'FloatBorder' },
		-- 	  { '╰', 'FloatBorder' },
		-- 	  { '│', 'FloatBorder' },
		-- 	},
		--   }
		--   vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
		--   return result, win, buf
		-- end
	}
}

M.packer.register = function(self, packer)
	local use = packer.use
	-- Unmaintained since August, 202
	-- NOTE: Do not include into lazy.nvim
	use({
		"wbthomason/packer.nvim"
	})
end

return M
