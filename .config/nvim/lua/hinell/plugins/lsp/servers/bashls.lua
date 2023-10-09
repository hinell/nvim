-- @module bashls
-- M
-- bashls LSP config
local M = {}
M.config = {
	-- NOTE: Update this when zsh tree-sitter grammar is available
	-- TODO: [September 28, 2023] Disable formatter, use efm one
	filetypes={ "sh", "bash", "zsh" }
}

M.init = function(self, cfg)
	return vim.tbl_deep_extend("keep", cfg or {}, M.config)
end

return M
