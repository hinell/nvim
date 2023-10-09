-- Ui plugins
local M = {}

M.init = function(self, pm)

	local use = pm.use
	-- TODO: [December 07, 2023] remove
	-- Vertical lines hilghlighting scope of the current
	-- textual symbol
	-- use({
	-- 	"hinell/indent-blankline.nvim",
	-- 	enabled = false,
	-- 	event = "BufReadPre",
	-- 	config = function()
	--
	-- 		-- LuaFormatter off
	-- 		local config = require("ibl.config").default_config
	-- 		config.indent.char     = "│"
	-- 		config.indent.tab_char = "│" -- config.indent.char
	-- 		config.debounce        = 512
	-- 		-- LuaFormatter on
	--
	-- 		require("ibl").setup(config)
	--
	-- 	end
	-- })

	-- like lukas-reineke/indent-blankline.nvim, but better

	require("hinell.plugins.ui.hlchunk"):init(pm)
	use({
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		dependencies = {"nvim-treesitter/nvim-treesitter"},
		config = function()
			-- vim.cmd("TSContextEnable")
			require("treesitter-context").setup()
		end
	})

	require("hinell.plugins.ui.lualine"):init(pm)
	require("hinell.plugins.ui.statuscolumn"):init(pm)
	require("hinell.plugins.ui.nvim-tree"):init(pm)
	require("hinell.plugins.ui.neo-tree"):init(pm)
	require("hinell.plugins.ui.telescope-tabs"):init(pm)
	require("hinell.plugins.ui.telescope-todo-comments"):init(pm)

	-- Virtual column at 80 char
	use({
		enabled = true,
		"lukas-reineke/virt-column.nvim",
		config = function()
			-- Extend default virt-column config
			require("virt-column").update({
				virtcolumn = "80, 120"
				-- char = '▕'
			})
		end
	})

	-- Virtual column at 80 char
	-- Shows bugs when opening a binary file
	-- ref: https://github.com/xiyaowong/virtcolumn.nvim/issues/6
	use({
		enabled = false,
		"xiyaowong/virtcolumn.nvim",
		config = function()
			-- vim.g.virtcolumn_char  = '▕'
			vim.g.virtcolumn_char = "┃"
			vim.g.virtcolumn_priority = 5 -- priority of extmark
			vim.opt.colorcolumn = "80,120"
		end
	})

	use({
		-- stdlib for lua
		"nvim-lua/plenary.nvim",
		config = function() require("plenary.filetype").add_file("json-like") end
	})
	-- Better UI
	use({
		"stevearc/dressing.nvim",
		config = require("hinell.plugins.ui.dressing").config
	})

	-- LSP status for taskbar (line below the window)
	use({
		"nvim-lua/lsp-status.nvim",
		config = function()
			-- require("lsp-status").setup()
		end
	})

	require("hinell.plugins.ui.bufferline"):init(pm)
	-- Plugin is unmaintained
	-- REMOVE: [October 17, 2023] Description
	-- Dim unfocused windows
	-- use({
	-- 	disabled = true,
	-- 	"sunjon/shade.nvim",
	-- 	config = function()
	-- 		require("shade").setup({
	-- 		  overlay_opacity = 70,
	-- 		  opacity_step = 1
	-- 		})
	-- 	end
	-- })

	-- TODO: [October 05, 2023] Consider to remove?
	-- https://github.com/axieax/urlview.nvim
	use({
		enable = false,
		"axieax/urlview.nvim",
		config = function() require("urlview").setup({}) end
	})

	use({
		enable = false,
		"smiteshp/nvim-navic",
		config = function() require("nvim-navic").setup({highlight = true}) end
	})

	-- A VSCode like winbar under Tabline
	-- Requires working LSP server
	-- see also: https://github.com/Bekaboo/dropbar.nvim
	use({
		"utilyre/barbecue.nvim",
		description = "Minimalist winbar under tabline",
		category = "ui",
		dependencies = {
			"neovim/nvim-lspconfig", "smiteshp/nvim-navic", "nvim-tree/nvim-web-devicons" -- optional
		},

		-- NOTE: keep this if you"re using NvChad
		after = "nvim-web-devicons",
		config = function()
			require("barbecue").setup({
				-- NOTE: you have to attach navic in lsp config then
				-- ref: https://github.com/utilyre/barbecue.nvim/tree/main
				attach_navic = false
			})
		end
	})

	-- Highlights colors inside buffers
	-- PERF: [November 24, 2023] Slow, disable for big files bigfile.lua
	use({
		"NvChad/nvim-colorizer.lua",
		description = "Fastest Neovim colorizer (actually it's very slow)",
		category = "ui",
		lazy = false,
		config = function() require("colorizer").setup({}) end
	})


end

return M
