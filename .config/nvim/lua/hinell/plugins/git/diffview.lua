
-- M
-- hinell-config-diffview
require("hinell.std")

local M = {}

M.legendary = {}
M.legendary.init = function(self,legendary)

	self.legendary = {}
	self.legendary.keymaps = {
			{ mode = { "n" },	description = "Tools: DiffView: open"			, ":DiffviewOpen<CR>"		}
		,	{ mode = { "n" },	description = "Tools: DiffView: open"			, ":DiffviewOpen<CR>"		}
		,	{ mode = { "n" },	description = "Tools: DiffView: close"			, ":DiffviewClose<CR>"		}
		,	{ mode = { "n" },	description = "Tools: DiffView: files history"	, ":DiffviewFileHistory<CR>"}
		,	{ mode = { "n" },	description = "Tools: DiffView: files focus"	, ":DiffviewFocusFiles<CR>" }
		,	{ mode = { "n" },	description = "Tools: DiffView: files toggle"	, ":DiffviewToggleFiles<CR>"}
		,	{ mode = { "n" },	description = "Tools: DiffView: file refresh"	, ":DiffviewRefresh<CR>"	}
		,	{ mode = { "n" },	description = "Tools: DiffView: files log"		, ":DiffviewLog<CR>"		}
	}

	self.legendary.autocmds = {
		{
			"User",
			opts = {
				pattern = "DiffviewDiffBufWinEnter"
			},
			function(e)
				-- Bind keymaps local to the DiffView buffer
				-- if e.file:match("Diff") then
				-- 	print("User autocmd -> ", e.file)
				-- end
	 			-- vim.notify("[hinell-config-diffview]: Diffview entered", vim.log.levels.DEBUG)
				local diffViewCfg = require("diffview.config")
				local diffviewLib = require("diffview.lib")

				local cfg		  = diffViewCfg.get_config()
				local view		  = diffviewLib.get_current_view()

				local wins = vim.api.nvim_tabpage_list_wins(view.tabpage)
				local bufs = {}

				for k, winId in pairs(wins) do
					-- print("Debug: wincfg []=" .. k)
					-- print(vim.inspect(vim.api.nvim_win_get_config(winId)))
					local bufId = vim.api.nvim_win_get_buf(winId)
					table.insert(bufs, bufId)
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
end

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	--TODO: [March 28, 2023] sindrets/diffview - Setupx
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

end

return M
