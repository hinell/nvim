-- @module jsonls config
-- M
-- jsonls config
M = {}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.config = {
	capabilities = capabilities,
	-- NOTE: we can use schemas from store
	-- https://github.com/b0o/schemastore.nvim
	settings = {
		json = {
			schemas = {
				lspserver = {
					description = "Lua LSP server config schema",
					fileMatch = { ".luarc.json" },
					url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json",
				},
				tsconfig = {
					description = "TypeScript compiler configuration file",
					fileMatch = { "tsconfig.json", "tsconfig.*.json" },
					url = "http://json.schemastore.org/tsconfig",
				},
				lerna = {
					description = "Lerna config",
					fileMatch = { "lerna.json" },
					url = "http://json.schemastore.org/lerna",
				},
				babel = {
					description = "Babel configuration",
					fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
					url = "http://json.schemastore.org/lerna",
				},
				-- TODO: [May 25, 2023] Deprecate for Rome tool
				eslint = {
					description = "ESLint js linter config",
					fileMatch = { ".eslintrc.json", ".eslintrc" },
					url = "http://json.schemastore.org/eslintrc",
				},
				rome = {
					description = "Rome js linter config",
					fileMatch = { "rome.json" },
					url = "./node_modules/rome/configuration_schema.json",
				},
				bucklescript = {
					description = "Bucklescript config",
					fileMatch = { "bsconfig.json" },
					url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json",
				},
				prettier = {
					description = "Prettier config",
					fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
					url = "http://json.schemastore.org/prettierrc",
				},
				vercel = {
					description = "Vercel Now config",
					fileMatch = { "now.json" },
					url = "http://json.schemastore.org/now",
				},
				stylelint = {
					description = "Stylelint config",
					fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
					url = "http://json.schemastore.org/stylelintrc",
				},
				-- lualanguageserver = {
				-- 	description = "Lua language server config",
				-- 	fileMatch = { ".luarc.json" },
				-- 	url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json"
				-- }
			},
		},
	},
}

M.init = function (self, cfg)
	return vim.tbl_deep_extend("keep", cfg, M.config)
end

return M
