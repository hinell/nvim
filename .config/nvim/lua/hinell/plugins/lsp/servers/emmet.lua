-- emmet.io LSP config for vscode-based emmet-helper
local M = {}
M.init = function(self, pm, conf)
	-- See
	-- https://github.com/olrtg/emmet-language-server
	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = "md,markdown,css,eruby,html,htmldjango,less,pug,sass,scss,typescriptreact,javascriptreact,vue",
		once = true,
		callback = function()
			local confLsp = {
				cmd = { "emmet-language-server", "--stdio" },
				root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
				-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
				-- **Note:** only the options listed in the table are supported.
				init_options = {
					---@type table<string, string>
					includeLanguages = {},
					--- @type string[]
					excludeLanguages = {},
					--- @type string[]
					extensionsPath = {},
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
					preferences = {},
					--- @type boolean Defaults to `true`
					showAbbreviationSuggestions = true,
					--- @type "always" | "never" Defaults to `"always"`
					showExpandedAbbreviation = "always",
					--- @type boolean Defaults to `false`
					showSuggestionsAsSnippets = false,
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
					syntaxProfiles = {},
					--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
					variables = {},
				},
			}

			vim.lsp.start(vim.tbl_extend("keep", confLsp, conf))
		end,
	})

end
return M
