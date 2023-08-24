--- @module efmls
-- M
-- efm general-purpose LSP config
local M = {}

local clang_formatIsOk, clang_format = pcall(require, "efmls-configs.formatters.clang_format")
local lua_frmatIsOk, lua_format = pcall(require, "efmls-configs.formatters.lua_format")
local clang_tidyIsOk, clang_tidy = pcall(require, "efmls-configs.formatters.clang_tidy")

M.config = {
	log_level = 5,
	init_options = {
		documentFormatting = true
	},

	settings = {
		rootMarkers = {
			".git/",
			"./github",
			".gitlab",
			".bitbucket",
			"./node_modules/"
		},
		languages = {
			-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
			javascript = {
				clang_format
			},
			typescript = {
				clang_format
			},
			json = {
				-- clang_format
				-- formatCommand = "clang-format -i ${INPUT}",
				-- BUG: [September 29, 2023] efm-langserver doesn't support json?
				-- See also logs at /tmp/efm-log.txt
				-- Remomve his config later:
				-- /home/alex/.config/efm-langserver/config.yaml
				formatCommand = "echo ${INPUT} > /tmp/efm-log.txt",
				formatStdin = true
			},
			lua = {
				lua_format
			},
			cpp = {
				clang_format,
				clang_tidy
			}
		}
	}
}

return M
