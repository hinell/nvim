-- @module M
-- M
-- Move around tree
-- TODO: [September 04, 2023] remove tree-climber
local M = {}

M.init = function(self, packer, legendary)
	local use = packer.use
	use({
		disable = true,
		"drybalka/tree-climber.nvim",
		config = function()
		end
	})

	-- local climber = require('tree-climber')
	-- legendary.keymaps({
	-- 	  { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus parent node (tree-sitter)",	"<A-k>",climber.goto_parent }
	-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus child node (tree-sitter)",	"<A-j>",climber.goto_child }
	-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus next node (tree-sitter)",	"<A-l>",climber.goto_next }
	-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus prev node (tree-sitter)",	"<A-h>",climber.goto_prev }
	-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus current node (tree-sitter)",	"in",climber.select_node }
	-- })
end
return M
