---@diagnostic disable: redefined-local
--- nvim-specific keymaps, global keymaps

local M = {}

M.keymaps = {
--{ { "mode" }, "lhs", "action/fn/shorctu", { desc= }
--
  { { "n", "v" }, "<C-S-B>", "<C-S-Q>" ,{ desc="Mode: Visual Block" } } -- CTRL+SHIFT+B
, { { "n", "v" }, "<C-S-V>", "<C-S-Q>" ,{ desc="Mode: Visual Block" } } -- CTRL+SHIFT+V

-----------------------------------------------------------------------clipboard
-- Win32 Style - Copy/Paste:
, { { "n", "v" }, "<C-X>", [["+x]]      ,{ desc="Editor: cut selection into Clipboard" } } -- CTRL+X
, { { "n", "v" }, "<C-C>", [["+ygv"*y]] ,{ desc="Editor: copy selection into Clipboard" } } -- CTRL+C
, { { "n", "v" }, "<C-V>", '"+gp`[v`]'  ,{ desc="Clipboard: insert text from (autolign)" } } -- CTRL+V
, { { "c" }, "<C-V>", "<C-R>+"          ,{ desc="Clipboard: insert text from default register" } } -- CTRL+V
, { { "i" }, "<C-V>", "<C-R>+"	        ,{ desc="Clipboard: insert text from default register" } } -- CTRL+V
-- , { { "s" }, "<C-V>", [[<C-R>_<C-O>""c<C-R>+]]    ,{ desc="Clipboard: insert text, discared selection" } } -- s_CTRL+V
, { { "n" }, "gp", "<CMD>normal `[v`]<CR>" ,{ desc="Clipboard: select pasted text" } } -- CTRL+V

---------------------------------------------------------------line-manipulation
, { { "n" }, "<C-S-K>", '"_dd', { desc="Line: delete" } }         -- CTRL+SHIFT+K
, { { "x" }, "<C-S-K>", '"_d',  { desc="Line: delete" } }         -- CTRL+SHIFT+K
, { { "i" }, "<C-S-K>", [[<CMD>normal "_dd<CR>]], { desc="Line: delete" } }   -- CTRL+SHIFT+K

, { { "n" } ,"<BS>"      ,"<BS><ESC>"     ,{ desc="Line: remove previous char" } }  -- BACKSPACE
, { { "n" } ,"<SPACE>"   ,"a<SPACE><ESC>" ,{ desc="Line: insert whitespace" } }  -- SPACEW
, { { "i" } ,"<SPACE>"   ,"<C-G>u<SPACE>" ,{ desc="Line: save undoblock & add space" } }  -- SPACEW
, { { "n" } ,"<ENTER>"   ,"o"             ,{ desc="Line: new" } } -- ENTER
, { { "n", "x" } ,"<C-ENTER>" ,"O"             ,{ desc="Line: new upwards" } } -- SHIFT+ENTER
, { { "i" } ,"<C-ENTER>" ,"<CMD>normal O<CR>"        ,{ desc="Line: new upwards" } } -- SHIFT+ENTER

, { { "x" }, "al" ,"^Og_", { desc="buffer: select inner sentence" } }
-- , { { "o" }, "yal" ,"normal g^vg_y<CR>", { desc="buffer: copy/yank inner sentence" } }
, { { "o" }, "al" ,"<CMD>normal! ^vg_<CR>", { desc="Editor: motion: inner sentence" } }
-- , { { "v" }, "al" ,"normal g^ g_", { desc="Editor: motion: inner sentence" } }
--
-- Removal of a word separated by space or puncutation
-- CTRL +DEL/BS- Remove space-separated world
-- SHIFT+DEL/BS- Remove punct-separated world
-- E[27;2;8  -      SHIFT+BS
-- E[27;6;8  - CTRL+SHIFT+BS
-- RESET:
, { { "i", "c", "n", "v"  } ,"E[27;2;8~", "<NOP>" ,{ desc="" } }
, { { "i", "c", "n", "v"  } ,"E[27;6;8~", "<NOP>" ,{ desc="" } }

, { { "i" }, "<C-Del>"		,[[<CMD>normal "_dwa<CR>]]			, { desc="Line: remove next word (see 'iskeyword')" } } -- i_CTRL+DEL
, { { "i" }, "<S-Del>"		,[[<CMD>normal <S-Right>"_dgi<CR>]]	, { desc="Line: remove next WORD (see 'iskeyword')" } } --i_CTRL+DEL
, { { "i" }, "<C-H>"		,[[ <CMD>normal "_db<CR>]]			, { desc="Line: remove previous word (see 'iskeyword')" } } --i_CTRL+BACKSPACE
, { { "i" }, "E[27;2;8~"	,[[ <CMD>normal "_db<CR>]]			, { desc="Line: remove previous WORD (see 'iskeywotc.)" } } --i_SHIFT+BACKSPACE

, { { "n" },"<C-Del>"		,[[<"_dw]]			,{ desc="Line: remove previous word (see 'iskeywotc.)" } } -- n_SHIFT+BACKSPACEE
, { { "n" },"<S-Del>"		,[[<Right>v<S-Right>"_d]]			,{ desc="Line: remove previous WORD (see 'iskeywotc.)" } } -- n_CTRL+SHIFT+BACKSPACE
, { { "n" }, "<C-H>"		,[[v<Right><C-Left>"_d]]			,{ desc="Line: remove previous word (see 'iskeywotc.)" } } -- n_CTRL+ACKSPACE
, { { "n" }, "E[27;2;8~"	,[[v<Right><S-Left>"_d]]			,{ desc="Line: remove previous WORD (see 'iskeywotc.)" } } -- n_SHIFT+BACKSPACE

, { { "n"  }, "cw" , "ciw" ,{ desc="Line: replace a word under cursor"  } } -- SHIFT+TAB
-- Like i_CTRL-U, but to the end of line
, { { "i" }, "<C-S-U>"  ,"<CMD>normal D<CR><Right>", { desc="Line: erase line after cursor (to the last char)" } } -- CTRL+SHIFT+U

----------------------------------------------------------------------navigation
--- Scrolling
, { { "n"      }, "<S-ENTER>", [[<CMD>echo "hinell: keymap:disabled"<CR>]] , { desc="Editor: scroll page (disabled)" } } -- SHIFT+ENTER
, { { "n", "v" }, "<S-Up>"   , [[<CMD>echo "hinell: keymap:disabled"<CR>]] , { desc="Editor: scroll page (disabled)" } } -- SHIFT+ENTER
, { { "n", "v" }, "<S-Down>" , [[<CMD>echo "hinell: keymap:disabled"<CR>]] , { desc="Editor: scroll page (disabled)" } } -- SHIFT+ENTER
--
--Scrolling
, { { "n", "v" }, "<C-U>", [[<CMD>echo "hinell: keymap:disabled"<CR>]] ,{ desc="Editor: scroll up   (disabled)" } } -- Disabled
, { { "n", "v" }, "<C-D>", [[<CMD>echo "hinell: keymap:disabled"<CR>]] ,{ desc="Editor: scroll down (disabled)" } } -- Disabled

, { { "n", "v" }, "<C-Up>"  , "<C-Y>", { desc="Editor: scroll up  " } } -- CTRL+UP - Scroll up
, { { "n", "v" }, "<C-Down>", "<C-E>", { desc="Editor: scroll down" } } -- CTRL+DOWN - Scroll down

, { { "n", "v" }, "<C-k>"  , "<C-Y>", { desc="Editor: scroll up  " } } -- H+UP - Scroll up
, { { "n", "v" }, "<C-j>"  , "<C-E>", { desc="Editor: scroll down" } } -- J+DOWN - Scroll down
, { { "n", "v" }, "<C-S-j>", [[<CMD>echo "hinell: keymap:disabled"<CR>]] ,{ desc="Editor: scroll down fast (disabled)" } } -- Disabled

, { { "i" }, "<C-Up>"   , "<ESC><C-Y>gi", { desc="Editor: scroll up  " } }
, { { "i" }, "<C-Down>" , "<ESC><C-E>gi", { desc="Editor: scroll down" } }

, { { "n" }, "<C-w>gf"  , ":tab drop <cfile><CR>", { desc="Editor: jumpt to a file under cursor" } }

, { { "n", "x" }, "gf"		, "<CMD>tab drop <cfile><CR>", { desc="Editor: jumpt to a file under cursor" } }
-- , { { "n" }, "gf"		, ":tab drop fnameescape(expand('<cfile>'))<CR>", { desc="Editor: jumpt to a file under cursor" } }
-- vim.cmd("abbreviate gf :tab drop fnameescape(expand('<cfile>'))<CR>")
-- Buffer: jump to start/middle/end

--------------------------------------------------------------------------window

-- , { { "v", "n" }, ""             , "<ESC><M>gi" ,{ desc="Editor: jump to the middle of the window" } }

, { { "n" }, "<C-N>",  function()
		local newvim = vim.fn.system("xterm -fs 10 -fa 'JetBrainsMono Nerd Font Mono' -e nvim & disown")
		-- local newvim = vim.system({ "nvim-x" }, { text = true, detach = true })
	end
	,{ desc="Workspace: new window"    }

	}
, { { "v", "n" }, "<C-S-Home>", "<S-H>"              ,{ desc="Editor: move cursor to the top of the window"    } }
, { { "v", "n" }, "<C-S-End>" , "<S-L>"              ,{ desc="Editor: move cursor to the bottom of the window" } }
-- , { { "v", "n" }, "E[1;6H", [[echo  CTRL+HOM is hit]] ,{ desc="Editor: jump to the bottom of the window" } }
-- , { { "v", "n" }, "E[1;6F", [[echo  CTRL+END is hit]] ,{ desc="Editor: jump to the bottom of the window" } }


, { { "v" }, "<C-A>", "0ggo<C-End>"         ,{ desc="Editor: select all text" } } -- CTRL+A
, { { "n" }, "<C-A>", "0ggv<C-End>"         ,{ desc="Editor: select all text" } } -- CTRL+A

, { { "n" }, "<A-Left>"    , "<C-O>"        ,{ desc="Editor: jumplist: jump to prev pos" } } -- ALT+LEFT
, { { "n" }, "<A-Right>"   , "<C-I>"        ,{ desc="Editor: jumplist: jump to next pos" } } -- ALT+RIGHT
, { { "i" }, "<A-Left>"    , "<ESC><C-O>gi" ,{ desc="Editor: jumplist: jump to prev pos" } } -- ALT+LEFT
, { { "i" }, "<A-Right>"   , "<ESC><C-I>gi" ,{ desc="Editor: jumplist: jump to next pos" } } -- ALT+RIGHT

-------------------------------------------------------------------------history
-- Win32-style shortcuts
, { { "n", "v", "i" }, "<C-S>" ,"<CMD>update<CR>"   ,{ desc="Editor: save" } } -- CTRL+S
, { { "c" }, "<C-S>" ,"<CMD>update | redraw<CR>"    ,{ desc="Editor: save" } } -- CTRL+S

, { { "i" }, "<C-Z>"  , "<CMD>undo<CR>", { desc="Editor: history: undo" } } -- CTRL+Z
, { { "i" }, "<C-S-Z>", "<CMD>redo<CR>", { desc="Editor: history: redo" } } -- CTRL+SHIFT+Z
, { { "n", "v" }, "<C-Z>"  , "<CMD>undo<CR>", { desc="Editor: history: undo" } } -- CTRL+Z
, { { "n", "v" }, "<C-S-Z>", "<CMD>redo<CR>", { desc="Editor: history: redo" } } -- CTRL+SHIFT+Z

----------------------------------------------------------------------completion

} -- M.keymaps END


-----------------------------------------------------------------------indenting
M.keymaps = vim.list_extend(M.keymaps, {
	  { { "n" },   "<TAB>" , ">>"   ,{ desc="Line: shift to the right" } } -- TAB
	, { { "n" }, "<S-TAB>" , "<<"   ,{ desc="Line: shift to the left"  } } -- SHIFT+TAB

	-- , { { "v" },   "<TAB>" , function() if not require("cmp").visible() then vim.cmd(">gv") end end  ,{ desc="Line: shift to the right " } } -- TAB
	-- , { { "v" }, "<S-TAB>" , function() if not require("cmp").visible() then vim.cmd("<gv") end end  ,{ desc="Line: shift to the left  "  } } -- SHIFT+TAB

	-- NOTE: [December 05, 2023] Interferes with luasnip when  <CMD> is used: en  try-- NOTE: [December 05, 2023] Interferes with luasnip when  <CMD> is used: en  try
	, { { "x" },   "<TAB>" , ">gv" ,{ desc="Line: shift to the right" } } -- TAB
	, { { "x" }, "<S-TAB>" , "<gv" ,{ desc="Line: shift to the left"  } } -- SHIFT+TAB
})

---------------------------------------------------------------------git-actions
-- TODO: [November 28, 2023] Move to api.nvim
--- Wrapper with error
--- @usage if buf_get_file_name() then end
--- @param bufnr number|nil - buffern number
--- @return string|nil
M.buf_get_file_name = function(bufnr)
	bufnr = type(bufnr) == "number" and bufnr or 0
	---@type any
	local file = vim.api.nvim_buf_get_name(0)
	file = vim.fn.resolve(file)
	if file == "" then file = vim.fn.expand("%") end
	if type(file) == "string" and file == "" then
		vim.notify("hinell-keymap: no file to stage", vim.log.levels.INFO)
		return nil
	end
	return file
end


local command_stdx_cb = function(err, data)
	if err then
		print(err)
	end
	if data then
		print(data)
	end
end

M.keymaps = vim.list_extend(M.keymaps, {
	{
		itemgroup = "Git",
		description = "Git commands",
		keymaps = {

			{ { "n" }, "<C-g>ci", function()
				if vim.bo.buftype ~= "" then return end

				local command_list = { "git", "commit" }
				vim.system(command_list, {
					stdout = command_stdx_cb,
					stderr = command_stdx_cb,
					text = true,
				})
				if vim.api.nvim_buf_get_name(0) ~= "" then
					vim.cmd("edit")
				end
			end, { desc="file: git commit" } }, -- CTRL-g cid

			{ { "n" }, "<C-g>cia", function()
				if vim.bo.buftype ~= "" then return end
				vim.ui.input({ prompt = "git commit: skip message editing? (y/N)): "}, function(input)
					if input == nil then
						return
					end
					local command_list = { "git", "commit", "--amend", "--no-edit" }
					if input == "" or input:match("[nN]") then
						command_list[#command_list] = nil
					end

					vim.system(command_list, {
						stdout = command_stdx_cb,
						stderr = command_stdx_cb,
						text = true,
					})
					if vim.api.nvim_buf_get_name(0) ~= "" then
						vim.cmd("edit")
					end
				end)
			end, { desc="file: git commit --amend" } }, -- CTRL-g cia

			{ { "n" }, "<C-g>fa", function()
				if vim.bo.buftype ~= "" then return end
				local file = M.buf_get_file_name()
				if file then
					vim.system({ "git", "add", file }, { text = true }, function()
						vim.schedule_wrap(function()
							vim.notify("git add: " .. file .. " - staged by git", vim.log.levels.INFO)
						end)
					end)
					vim.cmd("edit")
				end
			end, { desc="file: git stage | add" } }, -- CTRL-g a

			{ { "n" }, "<C-g>fr" , function()
				if vim.bo.buftype ~= "" then return end
				local file = M.buf_get_file_name()
				if file then
					vim.system({ "git", "reset", file }, { text = true }, function(result)
						vim.schedule_wrap(function()
							vim.notify("git reset: " .. file .. " - reset by git", vim.log.levels.INFO)
						end)
					end)
					vim.cmd("edit")
				end
			end, { desc="file: git unstage / reset current file" } }, -- CTRL-g un

			{ { "n" }, "<C-g>fco" , function()
				if vim.bo.buftype ~= "" then return end
				local file = M.buf_get_file_name()
				if file then
					vim.ui.input({ prompt = file .. " - checkout to version of git HEAD state? (y/N)): "}, function(input)
						if input == nil or input == "" or input:match("[nN]")
						then
							return
						end
						local command_list = { "git", "checkout", "@" , file }
						vim.system(command_list, { text = true }, function(result)
							vim.schedule_wrap(function()
								vim.cmd("redraw")
								vim.notify( table.concat(command_list, " ") .. " : checked out by git", vim.log.levels.INFO)
								vim.cmd("edit")
							end)
						end)
						vim.cmd("edit")
					end)
				end
			end, { desc="file: git checkout current file to HEAD" } } -- CTRL-g un

		}
	}
})

M.keymaps = vim.list_extend(M.keymaps, {
	{
		itemgroup = "Session",
		description = "save and manage neovim state",
		keymaps = {
		  { { "n", "v", "i", "x" }, "<CMD>mksession!<CR>", nil, { desc="Session: save (force)" } }
		, { { "n", "v", "i", "x" }, "<CMD>source Session.vim<CR>", nil, { desc="Session: restore (force)" } }
		}
	}
})

M.keymaps = vim.list_extend(M.keymaps, {
	  { { "n", "v" }, "E[3;5~" ,"za", { desc= "Editor: fold toggle recursively" } }
	, { { "n", "v" }, "zl", "zr", { desc="Editor: fold less" } }
	, { { "n", "v" }, "zL", "zR", { desc="Editor: fold less all" } }
	, { { "n", "v" }, "zm", nil , { desc="Editor: fold more" } }
	, { { "n", "v" }, "zM", nil , { desc="Editor: fold more all" } }
})


----------------------------------------------------------------------------tabs
M.keymaps = vim.list_extend(M.keymaps, {
	  { { "n" }, "<C-T>", "<CMD>tabnew<CR>" } -- CTRL+T
	, { { "n", "v", "i", "x" , "o" }, "<F28>", vim.cmd.tabclose } -- CTRl+F4

	-- If the same file is opened in multiple windows then
	-- , { { "n", "i", "v" }, "<C-W>c",function()
	-- 		 vim.cmd("<CMD>:bdelete<CR>")
	-- 	end, { desc="Editor: delete/close" } }    -- CTRL+W+C
	, { { "n", "i", "v" }, "<C-W>q", "<CMD>:bdelete<CR>",{ desc="Window: close file's window[s] and delete buffer" } }    -- CTRL+W+Q

	, { { "n", "v", "c" }, "E[5;6~", function()
		local tabs      = vim.api.nvim_list_tabpages()
		local currentTab = vim.api.nvim_get_current_tabpage()
		local isFirst   = tabs[1] == currentTab
		if isFirst then
			vim.cmd([[tabmove]])
		else
			vim.cmd([[tabmove -1]])
		end
	end, { desc= "Tabs: move to the left" } }  -- CTRL+SHIFT+PGUP

	, { { "n", "v", "c" }, "E[6;6~", function()
		local tabs      = vim.api.nvim_list_tabpages()
		local currentTab = vim.api.nvim_get_current_tabpage()
		local isLast    = tabs[#tabs] == currentTab

		if isLast then
			vim.cmd([[0tabmove]])
		else
			vim.cmd([[tabmove +1]])
		end
	end, { desc= "Tabs: move to the right" } }  -- CTRL+PgUp
	, { { "n", "x", "i", "c" }, "<C-PageUp>"  , "<CMD>tabprevious<bar>redraw<CR>", {  desc= "Tabs: focus previous" } } -- c_CTRL-PgUp
	, { { "n", "x", "i", "c" }, "<C-PageDown>", "<CMD>tabnext<bar>redraw<CR>"    , {  desc= "Tabs: focus next" } } -- c_CTRL-PgDw
})

-- CTRL-0 to switch tab
-- M.keymaps = vim.list_extend(M.keymaps,{
-- 	{ { "n", "v", "i", "s", "x" }, "<C-0>", function()
-- 		-- This is telescope-independent way to switch tabs
-- 		local tabs      = vim.api.nvim_list_tabpages()
-- 		local currentTab = vim.api.nvim_get_current_tabpage()
-- 			  vim.ui.input({
-- 			  prompt = ("Enter tab number (%s): "):format(#tabs)
-- 			, default = currentTab
-- 			}, function(input)
-- 				if input then
-- 					vim.cmd([[tabnext ]] .. input)
-- 				else
-- 					vim.notify("CTR-0 aborted", vim.log.levels.INFO)
-- 				end
-- 			end)
-- 	end, { desc="Tabs: focus tab N" } } --CTRL+0
-- })

-- Setup CTRL-1 ... CTRL-9 keybindings
for i = 1, 9 do
	local keymap = 	{
		{ "n", "v", "i", "s", "x" }, "<C-" .. i .. ">"
		, function()
			local tabs = vim.api.nvim_list_tabpages()
			if i <= #tabs then
				vim.cmd([[tabnext ]] .. i)

				-- Buggy: don't allow to set empty tabpages
				-- vim.api.nvim_set_current_tabpage(i)
			end
		end
		,{ desc="Tabs: focus tab " .. i }
	}
	table.insert(M.keymaps, keymap)
end

M.init = function (self)


	local	legendaryOk ,legendary = pcall(require, "legendary")
	if legendaryOk then
		-- require("hinell.nvim-keymaps").keymaps:init()
		return self.legendary:init(legendary)
	end
	local keymaps = self.keymaps
	for key, entry in pairs(keymaps) do
		if entry.itemgroup then
			for key, value in pairs(entry.keymaps) do
				table.insert(keymaps, value)
			end
			goto loop_keymaps
		end

		local mode = entry[1]
		local key  = entry[2]
		local cmd  = entry[3]
		local opt  = entry[4]
		-- If command is nil, then don't add shortcut
		local ok = cmd and vim.keymap.set(mode, key, cmd, opt)
		::loop_keymaps::
	end

end

M.hinellToLegendaryKeymapSepc = function(entry)
	entry.mode = entry[1];
	entry[1] = entry[2] -- shortcut
	entry[2] = entry[3] -- command
	if entry[4] then
		entry.description = entry[4].desc;
		entry[4].desc = nil;
		entry.opts=entry[4];
		entry[3]=nil
	end
	return entry
end

M.legendary = {}
M.legendary.keymaps = M.keymaps

--- @brief I initialize keybinings either via built-in API or by Plugin
M.legendary.init = function(self, legendary)
        local keymaps = self.keymaps
        if legendary and legendary.keymaps then
                -- Conver to Legendary-friendly entry
                for key, entry in pairs(keymaps) do
					if entry.itemgroup then
						for key, entry in pairs(entry.keymaps) do
							M.hinellToLegendaryKeymapSepc(entry)
						end
						goto loop_keymaps
					end
					M.hinellToLegendaryKeymapSepc(entry)
					::loop_keymaps::
                end
				-- -Legendary plugin requires methods and extra fields removed
				keymaps = vim.list_slice(keymaps, 1, #keymaps)
				legendary.keymaps(keymaps)
        end
		return self
end

return M
