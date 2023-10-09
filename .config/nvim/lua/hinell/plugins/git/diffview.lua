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
			print(vim.inspect({ view }))
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

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if e.file == "DiffviewViewEnter"
				and legendary.diffviewKeymaps then
				local keymaps = self.legendary.diffviewKeymaps
					  keymaps = vim.tbl_map(function(entry)
						entry.opts = { buffer = e.buf }
						local output = entry
						return output
					  end, keymaps)
				legendary.keymaps(keymaps)
			end
		end
	}
}


M.config = function()

	local diffview = require("diffview")

	local config = {
		keymaps = {
			-- disable_defaults = true
		}
	,
	}

	config.hooks = {
		view_opened = function(view)
			local diffViewCfg = require("diffview.config")
			local diffviewLib = require("diffview.lib")

		end
	}

	config.merge_tool = {
		-- layout = "diff1_plain",
		layout = "diff2_vertical",
		disable_diagnostics = true,
		winbar_info = true
	}

	diffview.setup(config)
end


M.init = function(self, packer)
	local use = packer.use
	vim.g.diffview_nvim_loaded = true
	use({
		"sindrets/diffview.nvim",
		description = "Better diff and merge tool for git in neovim",
		dependencies = "nvim-lua/plenary.nvim",
		-- lazy = true,
		init = function()
			local legendaryIsOk, legendary = pcall(require, "legendary")
			assert(legendaryIsOk,legendary)
			legendary.keymaps(M.legendary.keymaps)
			legendary.autocmds(M.legendary.autocmds)
		end,
		-- config =M.config
	})


	-- NOTE: the following setup below is directly taken from
	-- diffview.nvim/plugin/diffview.lua
	-- so it may change in the future and get out of sync
		-- It's intended to avoid loading entire diffview on startup
	local command = vim.api.nvim_create_user_command

	local function completion(...)
		local diffview = require("diffview")
		return diffview.completion(...)
	end

	-- Create commands
	command("DiffviewOpen", function(ctx)
		local arg_parser = require("diffview.arg_parser")
		local diffview = require("diffview")
		diffview.open(arg_parser.scan(ctx.args).args)
	end, { nargs = "*", complete = completion })

	command("DiffviewFileHistory", function(ctx)
		local range

		if ctx.range > 0 then
			range = { ctx.line1, ctx.line2 }
		end

		local arg_parser = require("diffview.arg_parser")
		local diffview = require("diffview")
		diffview.file_history(range, arg_parser.scan(ctx.args).args)
	end, { nargs = "*", complete = completion, range = true })

	command("DiffviewClose", function()
		local diffview = require("diffview")
		diffview.close()
	end, { nargs = 0, bang = true })

	command("DiffviewFocusFiles", function()

		local diffview = require("diffview")
		diffview.emit("focus_files")
	end, { nargs = 0, bang = true })

	command("DiffviewToggleFiles", function()
		local diffview = require("diffview")
		diffview.emit("toggle_files")
	end, { nargs = 0, bang = true })

	command("DiffviewRefresh", function()
		local diffview = require("diffview")
		diffview.emit("refresh_files")
	end, { nargs = 0, bang = true })

	command("DiffviewLog", function()
		require("diffview");
		vim.cmd(("sp %s | norm! G"):format(
			---@diagnostic disable-next-line: undefined-global
			vim.fn.fnameescape(DiffviewGlobal.logger.outfile)
		))
	end, { nargs = 0, bang = true })

end

return M
