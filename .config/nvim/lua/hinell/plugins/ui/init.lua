-- @module M
-- M
-- Ui plugins
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	-- Vertical lines hilghlighting scope of the current
	-- textual symbol
	use({
		"lukas-reineke/indent-blankline.nvim",
		event="BufReadPre",
		config = function()
				local config = require("ibl.config").default_config
				config.indent.tab_char = config.indent.char
				require("ibl").setup(config)
		end
	})

	use({
		"nvim-treesitter/nvim-treesitter-context",
		requires = {
			"nvim-treesitter/nvim-treesitter"
		},
		config = function()
			-- vim.cmd("TSContextEnable")
			require("treesitter-context").setup()
		end
	})

	-- LuaFormatter off
	local uiPlugins = {
		"hinell.plugins.ui.statuscolumn",
		"hinell.plugins.ui.lualine",
		"hinell.plugins.ui.telescope-tabs",
		"hinell.plugins.ui.nvim-tree"
	}
	-- LuaFormatter on

	for i, uiPluginName in ipairs(uiPlugins) do
		local uip = require(uiPluginName)
		local methodName = ""
		if uip.packer and uip.packer.register then
			uip.packer:register(packer)
			methodName = "register"
		elseif uip.init then
			uip:init(packer, legendary)
			methodName = "init"
		else
			error(
				('%s: the require("%s").%s method is not found'):format(
					debug.getinfo(1).source,
					uiPluginName
				)
			)
		end
	end

	-- Virtual column at 80 char
	use({
		disable=false,
		"lukas-reineke/virt-column.nvim",
		config = function()
			-- Extend default virt-column config
			require("virt-column").update({
				virtcolumn = "80, 120"
			})
		end
	})

	use({
		--stdlib for lua
		"nvim-lua/plenary.nvim",
		config = function()
			require("plenary.filetype").add_file("json-like")
		end
	})
	-- Better UI
	use({
		"stevearc/dressing.nvim",
		config = require("hinell.plugins.ui.dressing").packer.config
	})

	-- LSP status for taskbar
	use({
		"nvim-lua/lsp-status.nvim",
		config = function()
			-- TODO: [May 11, 2023] Finish config
			-- Note: available only in 9.0.0-dev versions!
			-- require("lsp-status").setup()
		end
	})

	--
	-- Tabline with configurable look
	use({
		"akinsho/bufferline.nvim",
		-- tag = "v3.*",
		config = function()
			local bufferline = require("bufferline")
			requires = "nvim-tree/nvim-web-devicons"
			bufferline.setup({
				options = {
					separator_style = { "", "" },
					enforce_regular_tabs = false,
					mode = "tabs", -- Disable numberline to the right
					color_icons = false
				}
			}
			)
		end
	})

	-- Dim unfocused windows
	use({
		disable = true,
		"sunjon/shade.nvim",
		config = function()
			require("shade").setup({
			  overlay_opacity = 70,
			  opacity_step = 1
			})
		end
	})

	-- TODO: [October 05, 2023] remove

	-- Higlight cursor, cursor line, column number
	-- with custom colors
	-- use({
	-- 	"mvllow/modes.nvim",
	-- 	disable = true,
	-- 	-- tag = "v0.2.1",
	-- 	config = function()
	-- 		require("modes").setup({
	-- 			colors 		   = {
	-- 				-- insert = "#704343",
	-- 				insert = 0,
	-- 				-- insert = "#997733"
	-- 				visual = "#ffffff"
	-- 			},
	-- 			set_cursor     = false,
	-- 			set_cursorline = true,
	-- 			set_number     = true
	-- 		})
	-- 	end
	-- })

	-- TODO: [October 05, 2023] Consider to remove?
	-- https://github.com/axieax/urlview.nvim
	use({
		disable = true,
		"axieax/urlview.nvim", config = function()
			require("urlview").setup({}) -- TODO: Install & setup
		end
	})
end

M.legendary = {}
M.legendary.init = function(self, legendary)
	require("hinell.plugins.ui.statuscolumn").legendary:init(legendary)
	require("hinell.plugins.ui.nvim-tree").legendary:init(legendary)
end

return M
