-- @module yamls config
-- M
-- yamlls lsp config
local M = {}

M.config = {
	settings = {
		yaml = {
			schemas = {
				["http://json.schemastore.org/github-workflow"]    = "/.github/workflows/*.{yml,yaml}",
				["http://json.schemastore.org/github-action"]      = "/.github/action.{yml,yaml}",
				["http://json.schemastore.org/prettierrc"]         = "/.prettierrc.{yml,yaml}",
				["http://json.schemastore.org/stylelintrc"]        = "/.stylelintrc.{yml,yaml}",
				["http://json.schemastore.org/circleciconfig"]     = "/.circleci/**/*.{yml,yaml}",
				["http://json.schemastore.org/ansible-stable-2.9"] = "/roles/tasks/*.{yml,yaml}",
			},
		},
	},
}

M.init = function(self, cfg)
	return vim.tbl_deep_extend("keep", cfg, self.config)
end

return M
