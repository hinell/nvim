--- @module telescope-todo-comments
-- Todo comments configuration module
local M = {}

M.legendary = {}
M.legendary.funcs = {
	{
		description = "Workspace: list global TODO-s",
		function()
			local todoComments = require("telescope").extensions["todo-comments"]
			todoComments.todo()

		end
	}, {
		description = "Editor: list TODO-s local to file's folder",
		function()
			local todoComments = require("telescope").extensions["todo-comments"]
			todoComments.todo({
				-- cwd = vim.fn.expand("%:h"),
				attach_mappings = telescopeTabDrop,
				-- hack, lol
				-- todo's picker doesn't allow to use it against current file
				-- it's used to grep-search acorss folders.
				-- search_dirs = { vim.fn.expand("%:h") },
				grep_opened_file = true
			})
		end
	}
}

M.init = function(self, pm)
	local use = pm.use

	use({
		-- TODO: [April 28, 2023] Fix the default acti no
		-- TODO: [May 12, 2023] Make Todo search local todos!
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			-- TodoQuickFix lua require("todo-comments.search").setqflist(<q-args>)
			-- TodoLocList lua require("todo-comments.search").setloclist(<q-args>)
			-- TodoTelescope Telescope todo-comments todo <args>
			-- TodoTrouble Trouble todo <args>
			require("todo-comments").setup({
				signs          = false, -- disable icons in the left column
				sign_priority  = 8,
				merge_keywords = false,
				max_line_len   = 256,
				keywords = {
					-- LuaFormatter off
					TODO     = { icon = "🗹" ,color = "info" },
					-- HACK     = { icon = " " ,color = "warning" },
					-- WARN     = { icon = " " ,color = "warning", alt = { "WARNING", "XXX" } },
					PERF     = { icon = "⥁" ,color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE     = { icon = "🗈" ,color = "hint", alt = { "INFO", "REVIEW" } },
					-- TEST     = { icon = " " ,color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
					CONTINUE = { icon = "" ,color = "info"	},
					REMOVE   = { icon = "🯀 ",color = "warning"	,alt = { "REMOVE" } },
					BUG      = { icon = " ",color = "error", alt = { "FIXME" } },
					DPRCT    = { icon = " ",color = "warning", alt = { "FIXME" } },
					-- LuaFormatter on
				}
			})

			require("telescope").load_extension("todo-comments")

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local funcs = {
					{
						itemgroup = "TODO Palette",
						description = "Todo lists",
						funcs = M.legendary.funcs
					}
				}
				legendary.funcs(funcs)
			end
		end
	})

end
return M
