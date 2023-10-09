--- @module diffview
-- M
-- hinell-config-diffview
-- local std = require("std")

local M = {}

M = {}
M.legendary = {}
M.legendary.keymaps = {
	{

		itemgroup = "Git",
		description = "Git commands",
		keymaps = {
			  { mode = { "n" },description = "Editor: git: diffview: open"                  , "<CMD>DiffviewOpen<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: close"                 , "<CMD>DiffviewClose<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: files focus"           , "<CMD>DiffviewFocusFiles<CR>" }
			, { mode = { "n" },description = "Editor: git: diffview: files toggle"          , "<CMD>DiffviewToggleFiles<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: file refresh"          , "<CMD>DiffviewRefresh<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: files log"             , "<CMD>DiffviewLog<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: files history"         , "<CMD>DiffviewFileHistory<CR>"}
			, { mode = { "n" },description = "Editor: git: diffview: file history - current", "<CMD>DiffviewFileHistory %<CR>"}
		}
	}
}

M.legendary.autocmds = {
	{
		"User",
		opts = {
			once = true,
			-- pattern = "DiffviewDiffBufWinEnter",
			pattern = "DiffviewViewOpened"
		},
		function(e)
			-- Bind keymaps local to the DiffView buffer
			-- if e.file:match("Diff") then
			-- 	print("User autocmd -> ", e.file)
			-- end
			-- vim.notify("[hinell-config-diffview]: Diffview entered", vim.log.levels.DEBUG)
			if true then return true end
			local diffViewCfg = require("diffview.config")
			local diffviewLib = require("diffview.lib")

			local cfg	= diffViewCfg.get_config()
			local view	= diffviewLib.get_current_view()
			local wins	= vim.api.nvim_tabpage_list_wins(view.tabpage)
			local bufs	= {}

			for k, winId in pairs(wins) do
				-- print("Debug: wincfg []=" .. k)
				-- print(vim.inspect(vim.api.nvim_win_get_config(winId)))
				local bufId = vim.api.nvim_win_get_buf(winId)
				table.insert(bufs, bufId)
				print(("%s: debug"):format(debug.getinfo(1).source))
				print(string.format("Debug: buf ft? -> %s", vim.inspect(vim.api.nvim_buf_get_option(bufId, "filetype"))))
				print("Debug: buf name? ->", vim.inspect(vim.api.nvim_buf_get_name(bufId)))
			end

			if e.file == "DiffviewViewEnter"
				and legendary.diffviewKeymaps then
				local keymaps = self.legendary.diffviewKeymaps
					  keymaps = vim.tbl_map(function(entry)
						entry.opts = { buffer = e.buf }
						local output = entry
						return output
					  end, keymaps)
				require("legendary").keymaps(keymaps)
			end
		end
	}
}


M.config = function(self)

	local diffview = require("diffview")
	diffview.setup({
		keymaps = {
		  -- disable_defaults = true
		},
		hooks = {
			view_opened = function(view)
				local diffViewCfg = require("diffview.config")
				local diffviewLib = require("diffview.lib")
				for key, value in pairs(view) do
					print(key)
				end
			end
		},
		merge_tool = {
			-- layout = "diff1_plain",
			layout = "diff2_vertical",
			disable_diagnostics = true,
			winbar_info = true
		}
	})
	local legendaryIsOk, legendary = pcall(require, "legendary")
	if not legendaryIsOk then
		return
	end
	legendary.keymaps(M.legendary.keymaps)
	legendary.autocmds(M.legendary.autocmds)
end

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	use({
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = M.config
	})

end

return M
