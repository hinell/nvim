-- @module M
-- M
-- Edito specific plugins
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use

	use({ "kevinhwang91/promise-async" })

	-- Highlight currently focused word
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				legendary.keymaps({
				  { mode = { "n", "v" }, "gcc", description = "Line: toggle comment: linewise | Comment plugin" }
				, { mode = { "n", "v" }, "gbc", description = "Block: toggle comment: blockwise | Comment plugin" }
				})
			end
		end,
	})

	use({
		"hinell/move.nvim",
		config = function()
			require("move").setup()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		setup = function()
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false

		end,
		config = function()
			require("hinell.plugins.editor.tree-sitter")
		end,
	})

	require("hinell.plugins.editor.tree-sitter-textobjects"):init(packer)
	require("hinell.plugins.editor.tree-sitter-crazymovement"):init(packer)
	require("hinell.plugins.editor.tree-sitter-autotag"):init(packer)

	-- A VSCode like winbar under Tabline
	use({
		"utilyre/barbecue.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"smiteshp/nvim-navic",
			"kyazdani42/nvim-web-devicons", -- optional
		},

		--NOTE: keep this if you"re using NvChad
		after = "nvim-web-devicons",
		config = function()
			require("barbecue").setup()
		end,
	})
	-- Workspace scuffold helper to generate gigignore
	use({
		"wintermute-cell/gitignore.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
		},
	})
	use({
		"hinell/tabs-history.nvim",
	})

	-- Surrounding text with different marks
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			local config = require("nvim-surround.config")
			local configDefault = config.default_opts
			require("nvim-surround").setup({
				-- surrounds = {
				-- 	["<S-{>"] = configDefault.surrounds["{"],
				-- 	["<S-}>"] = configDefault.surrounds["}"]
				-- },
				aliases = {
					["<S-{>"] = "{",
					["<S-}>"] = "}",
				},
			})
		end,
	})

	-- Remember and jump to the last position of the buffer when opened
	--NOTE: PROJECT IS NOT MAINTANINED; FORK
	use({
		"pchuan98/nvim-lastplace"
		, config = function()
			require("nvim-lastplace").setup {
				lastplace_ignore_buftype  = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds      = true
			}
		end
	})

	-- Disables unneeded features so it's easier to edit big files
	use({
		"LunarVim/bigfile.nvim"
	})

	-- Support for coffee-script
	use({
		disable = true,
		"kchmck/vim-coffee-script"
	})

	require("hinell.plugins.editor.base64"):init(packer)
	require("hinell.plugins.editor.vim-matchup").packer:register(packer)
	require("hinell.plugins.editor.duplicate").packer:register(packer)
	require("hinell.plugins.editor.nvim-cmp"):init(packer, legendary)
end
return M
