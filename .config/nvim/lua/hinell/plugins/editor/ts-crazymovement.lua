-- @module
-- M
-- https://github.com/theHamsta/crazy-node-movement
local M = {}
M.legendary = {}
M.legendary.init = function(self, opts)
	local node_movement = require("crazy-node-movement.node_movement")
	local legendaryIsOk, legendary = pcall(require, "legendary")
	if legendaryIsOk then
		local opts = {
			noremap = true
		}
		local keymaps ={
			{
				itemgroup = "Editor: AST",
				description = "Editor: AST: navigate Tree-Sitter/crazy-node-movement nodes",
				keymaps = {
					{ mode = { "x", "o" }, opts = opts, description="Editor: ast-tree: higlight current node",	"nc"   , node_movement.select_current_node }
					, { mode = { "n" }, opts = opts, description="Editor: ast: node: focus parent", "<M-k>", node_movement.move_move_up }
					, { mode = { "n" }, opts = opts, description="Editor: ast: node: focus child" , "<M-j>", node_movement.move_move_down }
					, { mode = { "n" }, opts = opts, description="Editor: ast: node: focus next"  , "<M-h>", node_movement.move_move_left }
					, { mode = { "n" }, opts = opts, description="Editor: ast: node: focus prev"  , "<M-l>", node_movement.move_right }

					, { mode = { "x", "o" }, description="Editor: ast-tree: select topmost node" ,	"ntm" , node_movement.select_up_topmost }
					, { mode = { "x", "o" }, description="Editor: ast: node: select parent"      ,	"<M-j>",node_movement.select_up }
					, { mode = { "x", "o" }, description="Editor: ast: node: select child"       ,	"<M-k>",node_movement.select_down }
					, { mode = { "x", "o" }, description="Editor: ast: node: select next"        ,	"<M-l>",node_movement.select_right }
					, { mode = { "x", "o" }, description="Editor: ast: node: select prev"        ,	"<M-h>",node_movement.select_left }
				}
			}
		}
		legendary.keymaps(keymaps)
	else
		vim.keymap.set({"v", "o" }, "nc"     , node_movement.select_current_node)
		vim.keymap.set({ "x", "o" }, "ntm"   , node_movement.select_up_topmost)
		vim.keymap.set({ "n" }, "<M-k>", node_movement.move_move_up, opts)
		vim.keymap.set({ "n" }, "<M-j>", node_movement.move_move_down, opts)
		vim.keymap.set({ "n" }, "<M-h>", node_movement.move_move_left, opts)
		vim.keymap.set({ "n" }, "<M-l>", node_movement.move_right, opts)
		vim.keymap.set({ "v" , "o" }, "<M-k>", node_movement.select_move_up)
		vim.keymap.set({ "v" , "o" }, "<M-j>", node_movement.select_move_down)
		vim.keymap.set({ "v" , "o" }, "<M-h>", node_movement.select_move_left)
		vim.keymap.set({ "v" , "o" }, "<M-l>", node_movement.select_right)
	end

end
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
			  local config  = {
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
			  }
			  require("nvim-treesitter.configs").setup(config)
			  M.legendary:init()
			  -- LuaFormatter on

	  end
	})

end

return M
