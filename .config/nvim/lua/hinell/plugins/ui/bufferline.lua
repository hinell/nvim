--- @module "bufferline.types"
-- Bufferline config
local M = {}
M.init = function(self, pm)

	local use = pm.use

	-- Tabline with configurable look (line below the window)
	use({
		"akinsho/bufferline.nvim",
		event = "UIEnter",
		description = "tabline",
		category = "ui",
		-- tag = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			-- see: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/ui.lua#L228
			local bufferline = require("bufferline")
			--- @type bufferline.UserConfig
			local config = {}

			config.options = {}
			-- config.options.separator_style      = {"", ""}
			-- config.options.separator_style      = { "", "" }
			config.options.numbers				= "ordinal"
			config.options.separator_style      = "thin"
			config.options.enforce_regular_tabs = false
			config.options.mode                 = "tabs" -- Disable numberline to the right
			config.options.color_icons          = false


			-- NOTE: [April 02, 2025] DO NOT ENABLE, UNTIL ISSUE RESOLVED AT:
			-- https://github.com/akinsho/bufferline.nvim/pull/1010
			config.options.diagnostics                  = false
			-- config.options.diagnostics                  = "nvim_lsp"
			-- config.options.diagnostics_update_on_event = true

			-- Deprecated after nvim-0.11
			-- config.options.diagnostics_update_in_insert = true


			-- -@type fun(count: number, level: string, errors: table<string, any>, ctx: table<string, any>): string
			config.options.diagnostics_indicator = function(count, level)

				-- Auto fetch signs from already defined diagnostics (if any)
				local diagnostics_map = vim.tbl_add_reverse_lookup({
				  ["error"	] = "DiagnosticSignError",
				  ["warning"] = "DiagnosticSignWarn" ,
				  ["info"	] = "DiagnosticSignInfo" ,
				  ["hint"	] = "DiagnosticSignHint" ,
				  ["other"	] = "DiagnosticSignUnknown" ,
				})
				--- @type table
				local nvim_sign_diagnostic = vim.fn.sign_getdefined(diagnostics_map[level:lower()])[1]
				if nvim_sign_diagnostic then
					local icon = nvim_sign_diagnostic.text
					return " " .. icon  .. count
				else
					vim.notify("hinell: bufferline: sign is not setup for " .. level, vim.log.levels.WARN)
					return " �".. count
				end

			end

			-- If neo-tree is found
			local neotreeOk, neotree = pcall(require, "neo-tree")
			if neotreeOk then
				config.options.custom_filter = function(buf_number, buf_numbers)
					if vim.bo[buf_number].filetype ~= "Nvim-tree" then
						return false
					end
					return true
				end

			end

			---@diagnostic disable-next-line: inject-field
			config.options.offsets = {}
			-- if nvim-tree is found
			-- local nvimtreeOk, nvimtree = pcall(require, "nvim-tree")
			if package.loaded["nvim-tree"] then
				local offset = {}

				offset.filetype   = "NvimTree"
				offset.text       = "WORKSPACE TREE"
				offset.text_align = "left" -- | "center" | "right"
				offset.highlight  = "Directory"
				offset.separator  = true

				table.insert(config.options.offsets, offset)
				config.options.custom_filter = function(buf_number, buf_numbers)
					if vim.bo[buf_number].filetype ~= "Nvim-tree" then
						return false
					end
					return true
				end

			end

			if package.loaded.diffview then
				local offset = {}
				offset.text      = " DIFF VIEW"
				offset.filetype  = "DiffviewFiles"
				offset.highlight = "PanelHeading"
				offset.separator = true
				table.insert(config.options.offsets, offset)
			end

			bufferline.setup(config)


			-- TODO: [December 04, 2023] Integrate with flash / leap?
			local legendaryIsOk, legendary = pcall(require, "legendary")
			if legendaryIsOk then
				local keymaps = {
					{
						mode = { "n" }, "<C-space><C-t>", bufferline.pick, opts = { noremap = true, desc = "Tabs: jump to a tab by keystroke" }
					}
				}
				legendary.keymaps(keymaps)
			end


		end
	})
end
return M
