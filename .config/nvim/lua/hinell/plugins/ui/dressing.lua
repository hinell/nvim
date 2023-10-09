--- dressing.nvim config
local M = {}

M.config = function()
	-- Neovim plugin to improve the default vim.ui interfaces
	--TODO: [October 20, 2023] Remove it due to telescope-ui-select
	require("dressing").setup({
		input  = {
			 enabled = false
		},
		select = {
			enabled   = true,
			fzf = {
			  window = {
				width  = -1.4,
				height = -1.4,
			  },
			}

			-- Options for fzf_lua selector
			,fzf_lua = {
			  winopts = {
				width  = -1.4,
				height = -1.4,
			  },
			}
			, builtin = {
				border    = "none",
				max_width = { 140, 0.8 },
				min_width = { 40, 0.2 },
				relative = "editor",
			}

			,get_config = function(opts)
				if opts.kind == "legendary.nvim" then
					return {
					  backend = {  "telescope", "builtin" },
					  telescope = {
						  -- Here should go a telescope config
					  }
					}
				else
					return {
					  window = {
						  width= -1.6
					  },
					  telescope = {}
					}
				end
			end
		}

	})
end

return M
