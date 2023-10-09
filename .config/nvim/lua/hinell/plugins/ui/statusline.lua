--- @module lualine
--- Lualine config
local M = {}
M.init = function(self, pm)
	local use = pm.use
	-- Bottom statusline
	use({
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = false },
		description = "A blazing fast and easy to configure Neovim statusline written in Lua.",
		config = function()
			-- ref: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff

			local function diff_source()
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed
					}
				end
			end
			local gitsignsOk, gitsigns = pcall(require, "gisigns")
			local lualine = require("lualine")
			local config = {}
			-- Custom components
			local components = {}
			components.filename = {
				"filename",
				path = 1,
				symbols = {
					modified = "[●]",
					readonly = "[]",
					unnamed = "[NO NAME]",
					newfile = "[NEW]",
				}
			}
			config.options = {}
			config.options.ignore_focus = {}

			-- config.options.component_separators = { left = "", right = "" }
			-- config.options.section_separators = { left = "", right = ""}
			-- config.options.section_separators = { left = "", right = ""}
			config.options.section_separators = { left = "", right = "" }

			config.options.theme = "auto"
			config.extensions = {
				"fzf", "man", "quickfix",
				-- "nvim-tree"
			}
			table.insert(config.extensions, {
				filetypes = { 'NvimTree' },
				sections = {
					lualine_a = { function()
						return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
					end },
					lualine_c = { components.filename }
				}
			})


			-- +-------------------------------------------------+
			-- | A | B | C                             X | Y | Z |
			-- +-------------------------------------------------+
			config.sections = {}
			config.sections.lualine_a = {
				{ "mode" }
			}
			config.sections.lualine_b = {
				"branch",
				{ "diff", source = gitsignsOk and diff_source or nil },
				{
					"diagnostics",
					-- sources = { "nvim_diagnostic" },
					-- symbols = {error = "E ", warn = "W ", info = "I ", hint = "H "}
					-- symbols = { error = " ", warn = " ", info = " ", hint = " " },
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
				}
			}
			config.sections.lualine_c = {
				components.filename
			}

			config.sections.lualine_x = {
				{
					'%w',
					cond = function()
						return vim.wo.previewwindow
					end,
				},
				"encoding",
				"fileformat",
				"filetype",
			}

			-- package-info.nvim integration
			if package.loaded["package-info"] then
				local package_info = require("package-info")
				table.insert(config.sections.lualine_c, package_info.get_status)
			end

			if package.loaded["profiler"] then
				local profiler = require("profiler")
				table.insert(config.sections.lualine_x, 1, profiler.jit.status)
			end

			local catpuccinThemeFlavor = vim.g.colors_name and vim.split(vim.g.colors_name, "-")[2] or ""

			-- local lspProgressOk, lspProgress = pcall(require, "lsp-progress")
			if package.loaded["lsp-progress"] then
				local lspProgress = require("lsp-progress")
				-- listen lsp-progress event and refresh lualine
				vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
				vim.api.nvim_create_autocmd("User", {
					group = "lualine_augroup",
					pattern = "LspProgressStatusUpdated",
					callback = require("lualine").refresh,
				})
				table.insert(config.sections.lualine_c, 1, lspProgress.progress)
			end

			config.inactive_sections = {}
			config.inactive_sections.lualine_c = { components.filename }
			lualine.setup(config)
		end
	})
end
return M
