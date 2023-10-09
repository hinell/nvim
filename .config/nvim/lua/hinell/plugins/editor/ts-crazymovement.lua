-- @module
-- M
-- https://github.com/theHamsta/crazy-node-movement
local M = {}

M.init = function(self, packer)
	local use = packer.use
	use({

		enabled = true,
		"hinell/crazy-node-movement",
		  dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects"
		  },
		  config = function()
			  -- LuaFormatter off
			  require("nvim-treesitter.configs").setup({
				  node_movement = {
					  enable = true,
					  keymaps = {
						  -- move_up	          = "<M-k>",
						  -- move_down           = "<M-j>",
						  -- move_left           = "<M-h>",
						  -- move_right          = "<M-l>",
						  --
						  -- select_up	          = "<M-k>",
						  -- select_down         = "<M-j>",
						  -- select_left         = "<M-h>",
						  -- select_right        = "<M-l>",
						  -- swap_left           = "<A-a-h>", -- will only swap when one of "swappable_textobjects" is selected
						  -- swap_right          = "<A-a-l>",
						  -- select_current_node = "an"
					  },
					  swappable_textobjects = {
						  "@function.outer"
						  ,"@parameter.inner"
						  ,"@statement.outer"
					  },
					  allow_switch_parents = false, -- more craziness by switching parents while staying on the same level, false prevents you from accidentally jumping out of a function
					  allow_next_parent = false, -- more craziness by going up one level if next node does not have children
					  cycle_siblings = true
				  }
			  })
			  -- LuaFormatter on

			  local node_movement = require("crazy-node-movement.node_movement")
			  local legendaryIsOk, legendary = pcall(require, "legendary")
			  if legendaryIsOk then
				  local keymaps ={
					  {
						  itemgroup = "Editor: AST",
						  description = "Navigate AST powered by Tree-Sitter/crazy-node-movement",
						  keymaps = {
							    { mode = { "v", "o" }, description="Editor: ast-tree: higlight current node(ts-crazymove)",	"an"   , node_movement.select_current_node }
							  , { mode = { "n" }, description="Editor: ast: node: focus parent (ts-crazymove)"       ,	"<M-k>",node_movement.move_up }
							  , { mode = { "n" }, description="Editor: ast: node: focus child (ts-crazymove)"        ,	"<M-j>",node_movement.move_down }
							  , { mode = { "n" }, description="Editor: ast: node: focus next (ts-crazymove)"         ,	"<M-l>",node_movement.move_right }
							  , { mode = { "n" }, description="Editor: ast: node: focus prev (ts-crazymove)"         ,	"<M-h>",node_movement.move_left }

							  , { mode = { "v" }, description="Editor: ast: node: select parent (ts-crazymove)"      ,	"<M-k>",node_movement.select_up }
							  , { mode = { "v" }, description="Editor: ast: node: select child (ts-crazymove)"       ,	"<M-j>",node_movement.select_down }
							  , { mode = { "v" }, description="Editor: ast: node: select next (ts-crazymove)"        ,	"<M-l>",node_movement.select_right }
							  , { mode = { "v" }, description="Editor: ast: node: select prev (ts-crazymove)"        ,	"<M-h>",node_movement.select_left }
						  }
					  }
				  }
				  legendary.keymaps(keymaps)
				else
					-- TODO: [October 20, 2023] Write legendary fallback
					vim.keymap.set({"v", "o" }, "an"   , node_movement.select_current_node)

					vim.keymap.set({ "n" }, "<M-k>", node_movement.move_move_up)
					vim.keymap.set({ "n" }, "<M-j>", node_movement.move_move_down)
					vim.keymap.set({ "n" }, "<M-h>", node_movement.move_move_left)
					vim.keymap.set({ "n" }, "<M-l>", node_movement.move_right)

					vim.keymap.set({ "v" }, "<M-k>", node_movement.select_move_up)
					vim.keymap.set({ "v" }, "<M-j>", node_movement.select_move_down)
					vim.keymap.set({ "v" }, "<M-h>", node_movement.select_move_left)
					vim.keymap.set({ "v" }, "<M-l>", node_movement.select_right)
			  end
		  end
	})

end

return M
