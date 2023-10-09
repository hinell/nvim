-- Editor specific plugins
local M = {}

M.init = function(self, pm)
	local use = pm.use

	-- TODO: [October 18, 2023] Maybe remove?
	use({
		enabled = false,
		"kevinhwang91/promise-async"
	})

	-- Highlight currently focused word
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				legendary.keymaps({
					  { mode = { "n", "v" }, "gcc", description = "Line: toggle comment: linewise | Comment plugin" }
					, { mode = { "n", "v" }, "gbc", description = "Block: toggle comment: blockwise | Comment plugin" }
					, {
						mode = { "i" },
						"E[0x8f;o;5~",
						"<ESC><Plug>(comment_toggle_linewise_current)gi",
						description = "Line: toggle comment (CTRL+/, Comment plugin)"
					}
					,
					{
						mode = { "n" },
						"E[0x8f;o;5~",
						"<Plug>(comment_toggle_linewise_current)",
						description = "Line: toggle comment (CTRL+/, Comment plugin)"
					}
					,
					{
						mode = { "x" },
						"E[0x8f;o;5~",
						"<Plug>(comment_toggle_linewise_visual)",
						description = "Line: toggle comment (CTRL+/, Comment plugin) | Visual"
					}
				})
			end
		end,
	})

	use({
		"hinell/move.nvim",
		config = function()
			local move = require("move")
			move.setup()
		end,
	})


	-- use({
	-- 	"hinell/tabs-history.nvim",
	-- })

	-- Surrounding text with different marks
	use({
		"kylechui/nvim-surround",
		enabled = true,
		description = "Add/change/delete surrounding delimiter pairs with ease.",
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

	-- Support for coffee-script
	use({
		disable = true,
		"kchmck/vim-coffee-script"
	})


	-- Complete brackets and alike upon hitting <CR>
	use({
		"windwp/nvim-autopairs",
		enabled = true,
		dependencies = "hrsh7th/nvim-cmp",
		config   = function()
			local config = {}
			config.check_ts = true
			config.map_cr   = true


			local cmpOk, cmp = pcall(require, "cmp")
			assert(cmpOk, "cmp is not found")
			if cmpOk then
				config.map_cr = false
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on(
					"confirm_done",
					cmp_autopairs.on_confirm_done()
				)

			end
			local autopairs = require("nvim-autopairs")
			autopairs.setup(config)

		end
	})

	require("hinell.plugins.editor.tree-sitter"):init(pm)
	require("hinell.plugins.editor.base64"):init(pm)
	require("hinell.plugins.editor.vim-matchup"):init(pm)
	require("hinell.plugins.editor.duplicate"):init(pm)
	require("hinell.plugins.editor.nvim-cmp"):init(pm)
	require("hinell.plugins.editor.bigfile"):init(pm)
	require("hinell.plugins.editor.leap"):init(pm)

	require("hinell.plugins.editor.ts-textobjects"):init(pm)
	require("hinell.plugins.editor.ts-crazymovement"):init(pm)
	require("hinell.plugins.editor.ts-climber"):init(pm)
	require("hinell.plugins.editor.ts-autotag"):init(pm)
	require("hinell.plugins.editor.ts-treesj"):init(pm)
	require("hinell.plugins.editor.keepyankpos"):init(pm)

end
return M
