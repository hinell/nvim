-- @module M
-- M
-- tree-sitter-textobjects
local M = {}

M.init = function(self, packer)
	local use = packer.use
	use({
	  "nvim-treesitter/nvim-treesitter-textobjects",
	  requires = "nvim-treesitter/nvim-treesitter",
	  after = "nvim-treesitter",
	  config=function()
	  	require'nvim-treesitter.configs'.setup {
		  textobjects = {
			enable = true,
			select = {
			  enable = true,
			  lookahead = true,
			  keymaps = {
				["aF"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["apP"] = { query = "@parameter.outer", query_group = "locals", desc = "Outer parameter" },
				["app"] = { query = "@parameter.inner", query_group = "locals", desc = "Inner parameter" },
				["aasr"] = { query = "@assignment.rhs", query_group = "locals", desc = "assgment - right hand" },
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				-- You can also use captures from other query groups like `locals.scm`
				-- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			  },
			  -- You can choose the select mode (default is charwise 'v')
			  --
			  -- Can also be a function which gets passed a table with the keys
			  -- * query_string: eg '@function.inner'
			  -- * method: eg 'v' or 'o'
			  -- and should return the mode ('v', 'V', or '<c-v>') or a table
			  -- mapping query_strings to modes.
			  selection_modes = {
				['@parameter.outer'] = 'v',
				['@function.outer'] = 'v',
				['@class.outer'] = 'v'
			  },
			  -- If you set this to `true` (default is `false`) then any textobject is
			  -- extended to include preceding or succeeding whitespace. Succeeding
			  -- whitespace has priority in order to act similarly to eg the built-in
			  -- `ap`.
			  --
			  -- Can also be a function which gets passed a table with the keys
			  -- * query_string: eg '@function.inner'
			  -- * selection_mode: eg 'v'
			  -- and should return true of false
			  include_surrounding_whitespace = true,
			},
		  },
		}
	  end
	})
	end
return M
