-- @module
-- M
-- https://github.com/theHamsta/crazy-node-movement
local M = {}

M.init = function(self, packer)
	local use = packer.use
	use({
		"theHamsta/crazy-node-movement",
		  requires = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects"
		  },
		  config = function()
			require "nvim-treesitter.configs".setup({
			  node_movement = {
			    enable=true,
				keymaps = {
				  move_up	          = "<A-k>",
				  move_down	          = "<A-j>",
				  move_left           = "<A-h>",
				  move_right          = "<A-l>",
				  -- swap_left           = "<A-a-h>", -- will only swap when one of "swappable_textobjects" is selected
				  -- swap_right          = "<A-a-l>",
				  select_current_node = "van"
				},

				swappable_textobjects = {
					 "@function.outer"
					,"@parameter.inner"
					,"@statement.outer"
				},
				allow_switch_parents = false, -- more craziness by switching parents while staying on the same level, false prevents you from accidentally jumping out of a function
				allow_next_parent = false, -- more craziness by going up one level if next node does not have children
			  }
			})
		  end
	})

end
-- legendary.keymaps({
-- 	  { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus parent node (tree-sitter)",	"<A-k>",climber.goto_parent }
-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus child node (tree-sitter)",	"<A-j>",climber.goto_child }
-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus next node (tree-sitter)",	"<A-l>",climber.goto_next }
-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus prev node (tree-sitter)",	"<A-h>",climber.goto_prev }
-- 	, { mode = { "n", "v", "o" }, description="buffer: ast-tree: focus current node (tree-sitter)",	"in",climber.select_node }
-- })
return M
