--- @module gitsigns
--- gitsigns configuration
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	use({
		disable = false,
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({

			})
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				legendary.funcs({
					  { description = "Buffer: git: hunk: next (gitsigns)" ,gitsigns.next_hunk }
					, { description = "Buffer: git: hunk: prev (gitsigns)" ,gitsigns.prev_hunk }
					, { description = "Buffer: git: hunk: stage undo (gitsigns)",gitsigns.stage_hunk }
					, { description = "Buffer: git: hunk: stage (gitsigns)" ,gitsigns.stage_hunk }

					, { description = "Buffer: git: hunk: reset (gitsigns)" ,gitsigns.reset_hunk }
					, { description = "Buffer: git: hunk: stage selection (gitsigns)", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end  }
					, { description = "Buffer: git: hunk: reset selection (gitsigns)", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end }
					, { description = "Buffer: git: hunk: preview (gitsigns)" ,gitsigns.preview_hunk }
					, { description = "Buffer: git: line: blame (gitsigns)" ,gitsigns.blame_line }
					, { description = "Buffer: git: line: blame toggle (gitsigns)" ,gitsigns.toggle_current_line_blame }
					, { description = "Buffer: git: stage (gitsigns)" ,gitsigns.stage_buffer }
					, { description = "Buffer: git: reset (gitsigns)" ,gitsigns.reset_buffer }
					, { description = "Buffer: git: diff this (gitsigns)" ,gitsigns.diffthis }
					, { description = "Buffer: git: hunk: toggle/show deleted (gitsigns)" ,gitsigns.toggle_deleted }
				})
				legendary.keymaps({
					{ mode = { "o", "x" }, description="Buffer: git: select hunk (gitsigns)", "ih", gitsigns.select_hunk },
					{ mode = { "n" }, description="Buffer: git: next hunk (gitsigns)", "]c", gitsigns.next_hunk },
					{ mode = { "n" }, description="Buffer: git: prev hunk (gitsigns)", "[c", gitsigns.prev_hunk }
				})
			end


		end
	})
end

return M
