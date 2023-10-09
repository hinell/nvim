--- @module efmls
-- efm general-purpose LSP config
local efmlsOk, efmls = pcall(require, "efmls-configs")
assert(efmlsOk, "efmls is not found")
if not efmlsOk then
	vim.notify(
		"efmls is not found; you can install it from https://github.com/mattn/efm-langserver",
		vim.log.levels.ERROR)
	return {}
end

local lua_format = require("efmls-configs.formatters.lua_format")
local clang_tidy = require("efmls-configs.formatters.clang_tidy")
local eslint_d   = require("efmls-configs.formatters.eslint_d")

local efmConfigs = {}
efmConfigs.javascript = {
	eslint_d,
	{
		formatCommand = "clang-format --assume-filename=.js",
		formatStdin = true
	}
}
efmConfigs.typescript = {
	eslint_d,
	{
		formatCommand = "clang-format --assume-filename=.ts",
		formatStdin = true
	}
}

-- LuaFormatter off
local M = {}
M.config = {
	log_level = 5,
	cmd = { "/usr/bin/efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "5" },
	filetypes = {
  		"blade",
		"c",
		"cpp",
  		"css",
  		"csv",
  		"dockerfile",
  		"elixir",
  		"eruby",
  		"gitcommit",
  		"html",
		"javascript",
		"javascript.jsx",
		"javascriptreact",
		"js",
		"jsm",
  		"json",
		"jsx",
  		"lua",
  		"make",
  		"markdown",
  		"perl",
  		"php",
  		"python",
  		"rst",
		"ruby",
		"rust",
  		"sh",
		"ts",
		"tsx",
		"typescript",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
  		"vim",
		"vue",
  		"yaml",
	},
	init_options = {
		codeAction              = true,
		completion              = false,
		documentFormatting      = true,
		documentRangeFormatting = true,
		documentSymbol          = true, -- this may interfere with navic.nvim
		hover                   = true,
	},
	settings = {
		version = 2,
		rootMarkers = {
			".bitbucket/",
			".git/",
			".github/",
			".gitlab/",
			".deps/",	-- c lang,neovim
			"node_modules/", -- node.js
			"third_party/",  -- c/c++ projects
		},
		languages = {
			-- https://github.com/mattn/efm-langserver#configuration-for-neovim-builtin-lsp-with-nvim-lspconfig
			js                 = efmConfigs.javascript,
			jsx                = efmConfigs.javascript,
			javascript         = efmConfigs.javascript,
			["javascript.tsx"] = efmConfigs.javascript,
			ts                 = efmConfigs.javascript,
			tsx                = efmConfigs.javascript,
			typescript         = efmConfigs.typescript,
			["typescript.tsx"] = efmConfigs.typescript,
			json = {
				{
					-- formatCommand = "clang-format -i ${INPUT}",
					formatCommand = "clang-format --assume-filename=.json",
					formatStdin = true

				}
			},
			lua = { lua_format },
			-- cpp = {
			-- 	clang_format,
			-- 	clang_tidy
			-- }
		}
	}
}
-- LuaFormatter on

M.init =
	function(self, cfg) return vim.tbl_deep_extend("keep", cfg, M.config) end

return M
