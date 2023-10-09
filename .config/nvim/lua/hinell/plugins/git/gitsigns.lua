--- @module gitsigns
--- gitsigns configuration
local M = {}

M.init = function(self, packer)
	local use = packer.use
	use({
		disable = false,
		description = "Git integration. In signcolumn shows changed/added/removed lines",
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({

			})

			gitsigns.stage_selection = function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end
			gitsigns.reset_selection = function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end

			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				-- LuaFormatter off
				legendary.funcs({
					{
						itemgroup = "Git",
						description = "Git commands",
						funcs = {
							{ description = "Editor: git: hunk: next"                     ,gitsigns.next_hunk },
							{ description = "Editor: git: hunk: prev"                     ,gitsigns.prev_hunk },
							{ description = "Editor: git: hunk: undo last stage"          ,gitsigns.undo_stage_hunk },
							{ description = "Editor: git: hunk: stage"                    ,gitsigns.stage_hunk },
							{ description = "Editor: git: hunk: reset"                    ,gitsigns.reset_hunk },
							{ description = "Editor: git: hunk: select"                   ,gitsigns.select_hunk },
							{ description = "Editor: git: hunk: preview diff"             ,gitsigns.preview_hunk },
							{ description = "Editor: git: hunk: preview deleted (toggle)" ,gitsigns.toggle_deleted },
							{ description = "Editor: git: line: blame"                    ,gitsigns.blame_line },
							{ description = "Editor: git: line: blame toggle"             ,gitsigns.toggle_current_line_blame },
							{ description = "Editor: git: stage"                          ,gitsigns.stage_buffer },
							{ description = "Editor: git: reset"                          ,gitsigns.reset_buffer },
							{ description = "Editor: git: diff this (vimdiff)"            ,gitsigns.diffthis },
							{ description = "Editor: git: hunk: stage selection", mode = { "x", "V", "v" }, gitsigns.stage_selection },
							{ description = "Editor: git: hunk: reset selection", mode = { "x", "V", "v" }, gitsigns.reset_selection }
						}
						}
				})

				-- LuaFormatter on
				legendary.keymaps({
					{
						itemgroup = "Git",
						description = "Git commands",
						keymaps = {
							{ mode = { "o", "x" }, description="Editor: git: hunk: select", "ih", gitsigns.select_hunk },
							{ mode = { "n" }, description="Editor: git: hunk: next", "]c", gitsigns.next_hunk },
							{ mode = { "n" }, description="Editor: git: hunk: prev", "[c", gitsigns.prev_hunk },
							{ mode = { "n" }, description="Editor: git: hunk: stage", "<C-g>ha", gitsigns.stage_hunk },
							{ mode = { "v" }, description="Editor: git: hunk: stage", "<C-g>ha", gitsigns.stage_selection},
							{ mode = { "n" }, description="Editor: git: hunk: reset", "<C-g>hr", gitsigns.reset_hunk },
							{ mode = { "v" }, description="Editor: git: hunk: reset", "<C-g>hr", gitsigns.reset_selection },
							{ mode = { "n" }, description="Editor: git: hunk: unstage", "<C-g>hu", gitsigns.undo_stage_hunk },
							{ mode = { "v" }, description="Editor: git: hunk: unstage", "<C-g>hu", gitsigns.undo_stage_hunk }
						}
					}
				})
			end


		end
	})
end

return M
