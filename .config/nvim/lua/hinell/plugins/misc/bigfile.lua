--- @ module bigfile
--- @module bigfile
-- Various tweaks for big file editing; disabling different features

-- NOTE: [November 05, 2023] This plugin may heavily interfere with
-- normal neovim cycle!
local M = {}
M.init = function(self, pm)
	local use = pm.use
	-- Disables unneeded features so it's easier to edit big files
	use({
		enabled = true,
		"LunarVim/bigfile.nvim",
		config = function(opts)
			vim.g.loaded_bigfile_plugin = not opts.enabled
			require("bigfile").setup({
			  features = {
				"indent_blankline",
				"illuminate",
				-- "lsp",
				"treesitter",
				"syntax",
				"matchparen",
				"vimopts",
				"filetype",
			  },
			})
		end
	})

end
return M

