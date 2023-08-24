--- @module dressing
--- dressing.nvim config
local M = {}

M.packer = {}
M.packer.config = function()
	-- Neovim plugin to improve the default vim.ui interfaces
	require("dressing").setup({
		input  = {
			 enabled = false
		},
		select = {
			border = "none",
			-- Options for fzf selector
			min_width = { 159, 0.8 },
			enabled = true
			,fzf = {
			  window = {
				width = -1.4,
				height = -1.4,
			  },
			}

			-- Options for fzf_lua selector
			,fzf_lua = {
			  winopts = {
				width = -1.4,
				height = -1.4,
			  },
			}
			,builtin  = {
			  min_width = { 159, 0.8 }
			}

			,get_config = function(opts)
				print(("%s: %s"):format(debug.getinfo(1).source, "opts"))
				print(vim.inspect(opts))
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
