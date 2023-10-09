-- @module hinell-plugins-legendary
-- local table     = require("table")
local M = {}
M.config = function(self)
--
	-- local toolbox   = require("legendary.toolbox")
	local filters   = require("legendary.filters")

	local keymaps = {
			{
				mode = { "n", "v", "i" }, "<C-S-P>" , function()
					local mode =vim.api.nvim_get_mode()
					if mode.mode == "n" then
						require("legendary").find()
					else
						require("legendary").find({ filters = { filters.current_mode() } })
					end
				end ,
				description = "Window: command palette: show per mode (Legendary)"
			}
			-- ,{ mode = { "n", "v" , "i" }, "<C-S-P>", "<CMD>Legendary<CR>", description= "Window: command palette: open (Legendary)"  }
		-- , {
		--
		-- 	description = "Developer: print selection",
		-- 	mode = { "n", "s", "v" },
		-- 	-- Remove <off> to enable
		-- 	"<off><C-K><C-K>",
		-- 	function
		--		local napi		= require("nvim-api")
		--		local feedkeys  = napi.feedkeys
		-- 		print("--------------------------CTRL-K-K invocation")
		-- 		-- vim.cmd(":startinsert")
		-- 		local table     = require("table")
		-- 		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		--
		-- 		-- [ buf, lnum, colnum, off ]
		-- 		local curA      = vim.fn.getcharpos("v")
		-- 		local curB      = vim.fn.getcharpos(".")
		-- 		local posStr    = "L:" .. curA[2] .. " C:" .. curA[3] .. "| L:" .. curB[2] .. " C:" .. curB[3]
		-- 		vim.fn.setreg([[+]], table.concat(vim.api.nvim_buf_get_lines(0, curA[2] - 1, curB[2], false), "\n"), "l")
		-- 		print("Current mode:", vim.fn.mode())
		--
		-- 		feedkeys("<ESC>", "nx", true)
		-- 		-- print("POS: ", curA[2]-1, curA[3], curB[2]-1, curB[3])
		-- 		feedkeys("<ESC>", "nx", true)
		-- 		print("----------------")
		-- 		print("Line [ ", vim.fn.line("'<"), vim.fn.line("'>"), " ]")
		-- 		print("Col  [ ", vim.fn.col("'<"), vim.fn.col("'>"), " ]")
		-- 		print("--------------------------CTRL-K-K invocation")
		-- 		-- vim.fn.setbufline(vim.fn.bufname(), 1, psoStr)
		-- 	end
		-- }
		--      , { mode = { "v" }, "<C-D>", function()
		-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		-- 	print("DEBUGGING: ", vim.fn.visualmode())
		-- 	-- vim.api.nvim_buf_set_lines(0, line, line, "DEBUG: " .. vim.fn.visualmode(), true)
		-- 	vim.api.nvim_set_current_line("DEBUG: " .. vim.fn.visualmode())
		-- end, description= "Debuggin: visualmode()" }
		, { mode = { "n" }, ":set list!<CR>", description = "Window: control char visibility: toggle " }
		, { mode = { "n" }, ":setlocal list!<CR>", description = "Window: control char visibility: toggle (local)" }
		-- , { mode = { "v" }			, "<C-K>cc","!column -t -s = -o = -R 1<CR>", description= "Selection: align by =" }
	}


	local autocmds = {
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
					"*/nvim/**/doc/*.txt"
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


	local functions = {
		{
			description = "Editor: command palettes",
			function()
				require("legendary").find({
					filters = {
						function(item, ctx)
							if item.opts and item.opts.buffer == ctx.buf then
								return item
							end
							return nil
						end
					}
				})
			end
		},
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
			function()
				require("material.functions").find_style()
			end
		},
		{
			description = "Window: settings: open nvim in configuration directory",
			function()
				local uv = vim.loop or vim.uv
				local handle, pid = uv.spawn("nvim-x", {
					detached = true,
					hide     = true,
					args = {
						"-c", '"cd ' .. vim.fn.stdpath("config") .. '"', "-p",
						"README.md",
						".config/nvim/lua/hinell/options.lua",
						".config/nvim/lua/hinell/nvim-keymaps.lua",
						".config/nvim/lua/hinell/plugins/editor/bigfile.lua",
						".config/nvim/lua/hinell/plugins/lsp/diagnostics.lua",
						".config/nvim/lua/hinell/init.lua",
						".config/nvim/lua/hinell/plugins/editor/init.lua",
						".config/nvim/lua/hinell/plugins/git/init.lua",
						".config/nvim/lua/hinell/plugins/lsp/init.lua",
						".config/nvim/lua/hinell/plugins/misc/init.lua",
						".config/nvim/lua/hinell/plugins/snippets/init.lua",
						".config/nvim/lua/hinell/plugins/themes/init.lua",
						".config/nvim/lua/hinell/plugins/ui/init.lua",
						".config/nvim/lua/hinell/plugins/utils/init.lua",
						".config/nvim/lua/hinell/plugins/web-dev-icons/init.lua",

					}
				}, function(code, signal) -- on exit
					print("exit code", code)
					print("exit signal", signal)
				end)
			end
		},
		{
			description = "Clipboard: copy current file path: absolute",
			function() local path = vim.fn.expand("%:p"); vim.fn.setreg("+", path); print("copied to the system clipboard: " .. path) end
		},
		{
			description = "Clipboard: copy current file path: relative",
			function() local path = vim.fn.expand("%:."); vim.fn.setreg("+", path); print("copied to the system clipboard: " .. path) end
		},
		{
			itemgroup = "File",
			description	= "File manipulation commands",
			funcs = {
				{
					description = "File: format (vim)", function()

					local napi		= require("nvim-api")
					local feedkeys  = napi.feedkeys
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
			}
		},
		{
			description = "Line: insert current date",
			function()
				local cur         = vim.fn.getcurpos();
				local bufname     = vim.fn.bufname()
				local curLine = vim.fn.getbufline(bufname, cur[2])[1]
				local curLinePrefix = string.sub(curLine, 1, cur[3])
				local curLineSuffix = string.sub(curLine, cur[3])
				local today = os.date("%A, %B %e, %Y")
				vim.fn.setbufline(bufname, cur[2], curLinePrefix .. today .. curLineSuffix)
			end
		},
		{

			itemgroup = "Devtools",
			description = "Neovim developer tools, editor specific routines",
			funcs = {
				{ description = "Editor: display items at cursor", vim.show_pos },
				{ description = "Editor: ast: display tree-sitter nodes tree", vim.treesitter.inspect_tree },
				{
					description = "Editor: Inspect items at a current cursor position",
					function() vim.inspect_pos() end
				},
				{
					description = "Editor: report current mode",
					function() print(vim.fn.mode()) end
				}
			}
		}
	}

	local legendary = require("legendary")
	legendary.ui = require("legendary.ui.format")

	legendary.setup({
		select_prompt = 'command palette',
		default_item_formatter = function(item, mode)
			local columValuesSource = legendary.ui.default_format(item)
			local columValuesReversed = { columValuesSource[3], columValuesSource[2], columValuesSource[1] }
			return columValuesReversed
		end,
		sort = {
			frecency = false
		},
		extensions = {
			-- diffview = false
		},
	})

	legendary.keymaps(keymaps)
	legendary.funcs(functions)
	legendary.autocmds(autocmds)
end

M.init = function(self, packer)
	local use = packer.use
	use({
		"hinell/legendary.nvim"
		, lazy = false
		, config = M.config
	})
end

return M
