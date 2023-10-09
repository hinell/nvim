--- OOP version of nvim built-in API relying heavily on inheritance
local M = {}

assert(vim,"Failure: loading module outside of the Vim/Neovim environment!")

M.feedkeys = function(key, mode, escape_ks)
	escape_ks = escape_ks or false
-- if not escape_ks then
-- 	C>
-- end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, escape_ks), mode, escape_ks)
end

M.cursor = {}
M.cursor.hasWordsBefore = function()
	unpack = unpack or table.unpack
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	-- Simply check if line isn't empty
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match("%s") == nil
end

M.cursors = { M.cursor, M.cursor }


M.buffers = {}
M.buffers.types = {}
M.buffers.types.nonEditable = {
	"NvimTree"
	, "Dressing"
	, "help"
	, "man"
}

M.buffers.types.special = {
	"nofile",
	"nowrite",
	"prompt",
	"help"
}

M.buffers.types.special.contains = function(self, v)
	return vim.tbl_contains(self, v)
end

-- This provides escaped keymaps for
M.keyboard = {}
M.keyboard.input  = {}
M.keyboard.input["<ESC>"]     = { true, true, false }
M.keyboard.input["gi"]        = { true, true, false }
M.keyboard.input["<C-Space>"] = { true, true, false }

for key, opts in pairs(M.keyboard.input) do
 	M.keyboard.input[key] = vim.api.nvim_replace_termcodes(key, unpack(opts))
end

M.Buffer = {}

--- Check that buffer has this map
--- @param bufnr number
--- @param lhs string
--- @param mode string
function M.Buffer:hasKeymap(bufnr, lhs, mode)
	-- If map is already setup over here, skip
	local bufferNKeymaps    = vim.api.nvim_buf_get_keymap(bufnr, mode)
	-- local bufferKeymapsDiagSetup = false
	for i, keymap in ipairs(bufferNKeymaps) do
		if keymap.lhs == lhs then
			-- bufferKeymapsDiagSetup = true
			return true
		end;
	end
	return false
end

M.commands = require("nvim-api.commands")
M.autocmds = require("nvim-api.autocmds")

return M
