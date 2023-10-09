-- @module M
-- M
-- Move around tree
local M = {}

-- TODO: [September 04, 2023]
M.init = function(self, pm)
	local use = pm.use
	use({
		enabled = false,
		"drybalka/tree-climber.nvim",
		config = function()
			print(("%s: tree-climber should work"):format(debug.getinfo(1).source))
			local keyopts = { noremap = true, silent = true }
			local opts = {
				highlight = true,
				timeout = 1000 * 3-- 3 secs
			}
			local treeClimber = require("tree-climber")
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local keymaps = {
					itemgroup = "Editor: AST",
					description = "Navigate AST powered by Tree-Sitter/tree-climber",
					keymaps = {
						{ mode = {"v", "o" }, "an"   , function() treeClimber.select_node(opts) end , opts = keyopts }
						, { mode = {"n", "v" }, "<M-k>", function() treeClimber.goto_child (opts) end , opts = keyopts }
						, { mode = {"n", "v" }, "<M-j>", function() treeClimber.goto_parent(opts) end , opts = keyopts }
						, { mode = {"n", "v" }, "<M-h>", function() treeClimber.goto_prev  (opts) end , opts = keyopts }
						, { mode = {"n", "v" }, "<M-l>", function() treeClimber.goto_next  (opts) end , opts = keyopts }
					}
				}
				legendary.keymaps(keymaps)
			else
				vim.keymap.set({"v", "o" }, "an"   , function() treeClimber.select_node(opts) end , keyopts)
				vim.keymap.set({"n", "v" }, "<M-j>", function() treeClimber.goto_parent(opts) end , keyopts)
				vim.keymap.set({"n", "v" }, "<M-k>", function() treeClimber.goto_child (opts) end , keyopts)
				vim.keymap.set({"n", "v" }, "<M-h>", function() treeClimber.goto_prev  (opts) end , keyopts)
				vim.keymap.set({"n", "v" }, "<M-l>", function() treeClimber.goto_next  (opts) end , keyopts)
			end
		end
	})
end
return M
