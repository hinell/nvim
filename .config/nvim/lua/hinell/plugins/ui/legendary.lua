-- @module hinell-plugins-legendary

-- local toolbox   = require("legendary.toolbox")
-- local filters   = require("legendary.filters")
-- local table     = require("table")
-- local legendary = require("legendary.filters")

comment         = require("Comment.api")
local napi		= require("hinell.nvim-api")
local feedkeys  = napi.feedkeys
				  require("hinell.std")

local M = {}
M.legendary = {}
M.legendary.keymaps = {
	{
		mode = { "n", "v", "i" }, "<C-S-P>" , function() require("legendary").find( --[[ { filters = { filters.current_mode() } } ]]) end ,
		description = "Window: open command palette (Legendary plugin)"
	}
	-- { mode = { "n", "v" , "i" }, "<C-S-P>", "Legendary", description= "Window: open command palette (Legendary plugin)" }
, {

	description = "Developer: print selection",
	mode = { "n", "s", "v" },
	-- Remove <off> to enable
	"<off><C-K><C-K>",
	function()
		print("--------------------------CTRL-K-K invocation")
		-- vim.cmd(":startinsert")
		local table     = require("table")
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))

		-- [ buf, lnum, colnum, off ]
		local curA      = vim.fn.getcharpos("v")
		local curB      = vim.fn.getcharpos(".")
		local posStr    = "L:" .. curA[2] .. " C:" .. curA[3] .. "| L:" .. curB[2] .. " C:" .. curB[3]
		vim.fn.setreg([[+]], table.concat(vim.api.nvim_buf_get_lines(0, curA[2] - 1, curB[2], false), "\n"), "l")
		print("Current mode:", vim.fn.mode())

		feedkeys("<ESC>", "nx", true)
		-- print("POS: ", curA[2]-1, curA[3], curB[2]-1, curB[3])
		feedkeys("<ESC>", "nx", true)
		print("----------------")
		print("Line [ ", vim.fn.line("'<"), vim.fn.line("'>"), " ]")
		print("Col  [ ", vim.fn.col("'<"), vim.fn.col("'>"), " ]")
		print("--------------------------CTRL-K-K invocation")
		-- vim.fn.setbufline(vim.fn.bufname(), 1, psoStr)
	end
}
--      , { mode = { "v" }, "<C-D>", function()
-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 	print("DEBUGGING: ", vim.fn.visualmode())
-- 	-- vim.api.nvim_buf_set_lines(0, line, line, "DEBUG: " .. vim.fn.visualmode(), true)
-- 	vim.api.nvim_set_current_line("DEBUG: " .. vim.fn.visualmode())
-- end, description= "Debuggin: visualmode()" }
, { mode = { "n" }, ":set list!<CR>", description = "Window: control char visibility: toggle " }
, { mode = { "n" }, ":setlocal list!<CR>", description = "Window: control char visibility: toggle (local)" }

, {
	mode = { "i" },
	"E[0x8f;o;5~",
	"<ESC><Plug>(comment_toggle_linewise_current)gi",
	description = "Line: toggle comment (CTRL+/, Comment plugin)"
}
,
{
	mode = { "n" },
	"E[0x8f;o;5~",
	"<Plug>(comment_toggle_linewise_current)",
	description = "Line: toggle comment (CTRL+/, Comment plugin)"
}
,
{
	mode = { "x" },
	"E[0x8f;o;5~",
	"<Plug>(comment_toggle_linewise_visual)",
	description = "Line: toggle comment (CTRL+/, Comment plugin) | Visual"
}
-- , { mode = { "v" }			, "<C-K>cc","!column -t -s = -o = -R 1<CR>", description= "Selection: align by =" }
}

M.legendary.commands = {
	-- These cannot be used to create long commands, use functions instead
	-- { 'Telescope', ':Telescope', description = 'Navigation: fuzzy search (Telescope)' },
	-- { 'Naviga go to tab (Telescope)', function() vim.cmd(':Telescope') end, description = 'Luanch Telescope menu to find files' },
	-- { 'Control: commands palette' , function() vim.cmd(':Legendary commands') end, description = 'Launch menu to select commands' },
	-- { 'Control: shortcuts palette ', function() vim.cmd(':Legendary kemaps') end, description = 'Launch menu to select keymaps/shortcuts' }
}

M.legendary.autocmds = {
	{
		"TabLeave",
		function(event)
			-- CONTINUE: [February 04, 2023] Focus left tab, not the right one! Finish this off
			-- See FocusPrevious.vim file!

			if not vim.g.tabs then
				vim.g.tabs = {
					last = { num = 0, name = "" }
				}
			end
			local last = vim.g.tabs.last
			last.name = vim.fn.bufname()
			last.num = vim.api.nvim_tabpage_get_number(0)
			-- print("vim.g.tabs.last.name => ", vim.g.tabs.last.name)
			-- print("last: ",vim.inspect(vim.g.tabs))
		end,
		description = "Open previous tab if current is closed"
	},
	{
		"TabEnter",
		description = "When closing tab, switch to the previous one",
		function()
			if vim.g.tabs and vim.g.tabs.last then
				-- TODO: [April 19, 2023] Finish this one!
				--
				-- print(vim.inspect(vim.g.tabs.last))
				if vim.g.tabs.last.num >= 1 then
					-- print("Last focused: ", vim.inspect(vim.g.tabs.last.num))
					-- print("tabnext " .. vim.g.tabs.last.num - tostring(1))
				end
				vim.g.tabs.last = nil
			end
		end
	},
	{
		"BufWinEnter",
		description = "Open help split to the right",
		opts = {
			pattern = {
				"*/nvim/runtime/doc/*.txt",
				"man://*(*)",
				"*/pack/packer/**/doc/*.txt"
			}
		},
		function(event)
			local fileType            = vim.opt.ft:get()
			local isHelpOrManRe, iEnd = vim.regex("^help\\|man$"):match_str(fileType)
			-- print("DEBUG: File type: ", fileType)
			if isHelpOrManRe then
				vim.cmd("wincmd L")
				-- TODO: Fix this "can't split winodw"  error
				-- print(vim.fn.getwininfo(event.buf))
			end
		end
	}
}

M.legendary.functions = {
	{
		description = "Window: extra chars visibility: toggle (conceallevel)",
		function()
			if vim.opt.conceallevel:get() == 0 then
				vim.opt.conceallevel = vim.b.conceallevel
				return
			end
			-- Stash latest conceal level
			if not vim.b.conceallevel then vim.b.conceallevel = vim.opt.conceallevel:get() end
			vim.opt.conceallevel = 0
		end
	},
	{
		description = "Window: settings: colorscheme: material: styles switch (Telescope)",
		require("material.functions").find_style
	}
	,
	{
		description = "Clipboard: copy current file path: absolute",
		function() vim.fn.setreg("+", vim.fn.expand("%:p")) end
	}
	,
	{
		description = "Clipboard: copy current file path: relative",
		function() vim.fn.setreg("+", vim.fn.expand("%")) end
	}
, {
	itemgroup = "File",
	description	= "File manipulation commands",
	funcs = {
		{
			description = "File: format (vim)", function()
			vim.notify(("formatter used: %s "):format(vim.opt_local.formatprg:get()), vim.log.levels.INFO);
			feedkeys("<C-A>gq", "t", true);
		end
		}
		, { description = "File: refresh (reload from disk)", function() vim.cmd(":e!") end }
		-- May not work on Windows well!
		, {
			description = "File: save (as root, superuser, sudo)",
			function()
				if jit.os == "Linux" then
					vim.cmd(":w ! sudo -A tee %")
				end
			end
		}
		, { description = "File: generate .gitignore", require("gitignore").generate }
	}
}, {
	itemgroup = "Plugins actions: install, update, sync",
	funcs = {
		{ description = "Plugins: update (Packer plugin)", function() vim.cmd(":PackerUpdate"); end }
		,
		{
			description = "Plugins: install (Packer plugin)",
			function()
				vim.cmd(":PackerInstall"); vim.cmd("PackerCompile")
			end
		}
		, { description = "Plugins: compile (Packer plugin)", function() vim.cmd(":PackerCompile"); end }
	, { description = "Plugins: compile & update (sync, Packer plugin)", function() vim.cmd(":PackerSync") end }
	, { description = "Plugins: status (Packer plugin)", function() vim.cmd(":PackerStatus") end }
	, {
		description = "Plugins: treesitter: install",
		function()
			vim.cmd(":TSInstall " .. vim.fn.input("Enter tree-sitter language name: "))
		end
	}
	}
}
, {
	description = "Line: insert current date",
	function()
		local cur         = vim.fn.getcurpos();
		local bufname     = vim.fn.bufname()
		local linecontent = vim.fn.getbufline(bufname, cur[2])[1]
		print(vim.inspect(linecontent))
		linecontent = String.insert(linecontent, vim.fn.getcurpos()[3], os.date("%A, %B %e, %Y"))
		vim.fn.setbufline(bufname, cur[2], linecontent)
	end
},
	{
		itemgroup = "Developer: neovim development tasks",
		funcs = {
			{ description = "Developer: inspect items at a current cursor position", vim.show_pos },
			{
				description = "Developer: report current mode",
				function()
					vim.api.nvim_set_current_line(vim.fn.mode())
				end
			},
			{
				description = "Developer: custom selector",
				function()
					vim.ui.select({
					  'apple'
					, 'banana'
					, 'mango'
					, "alpha"
					, "beta"
					, "gamma"
					}, {
						prompt = "Title",
						-- This is for dressing
						telescope = require("telescope.themes").get_cursor(),
					}, function(selected) print(selected) end)
				end
			}
		}
	},

	{
		itemgroup = "Plugins: Mason: dev-x tools manager",
		funcs = {
			{ description = "Mason: show manager window", function() vim.cmd("Mason") end },
		}
	}
}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	use({
		"mrjones2014/legendary.nvim"
		, config = function()
			require("legendary").setup({
			  extensions = {
				diffview = true
			  },
			})
		end
	})
end

M.init = function(self, legendary)
	legendary.keymaps(self.legendary.keymaps)
	legendary.funcs(self.legendary.functions)
	legendary.autocmds(self.legendary.commands)
	legendary.autocmds(self.legendary.autocmds)
end

return M
