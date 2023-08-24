--- @module hinell-config-nvim-keymaps
--- nvim-specific keymaps, global keymaps

local M = {}

M.keymaps = {
--{ { "mode" }, "shortcut", "action/fn/shorctu", { desc= }
--  { { "i", "n", "v", "x" }, "<C-S-B>", "<C-S-Q>"        ,{ desc="Mode: Visual Block" } } -- CTRL+V
  { { "n", "v" }, "<C-S-B>", "<C-S-Q>"        ,{ desc="Mode: Visual Block" } } -- CTRL+V
, { { "n", "v" }, "<C-S-V>", "<C-S-Q>"        ,{ desc="Mode: Visual Block" } } -- CTRL+V
, { { "n", "v" }, "<C-S-B>", "<C-S-Q>"        ,{ desc="Mode: Visual Block" } } -- CTRL+V

----------------------------------------------------------------------clipboard
-- Win32 Style - Copy/Paste:
, { { "n", "v" }, "<C-X>", [["+x]]      ,{ desc="Clipboard: cut  selection into clipboard" } } -- CTRL+X
, { { "n", "v" }, "<C-C>", [["+ygv"*y]] ,{ desc="Clipboard: copy selection into clipboard" } } -- CTRL+C
, { { "n", "v" }, "<C-V>", [["+gp]]     ,{ desc="Clipboard: insert text from" } } -- CTRL+V
, { { "c" }, "<C-V>", "<C-R>+"          ,{ desc="Clipboard: insert text from" } } -- CTRL+V
, { { "i" }, "<C-V>", "<C-R>+"	        ,{ desc="Clipboard: insert text from" } } -- CTRL+V
-- , { { "s" }, "<C-V>", [[<C-R>_<C-O>""c<C-R>+]]    ,{ desc="Clipboard: insert text, discared selection" } } -- s_CTRL+V

--------------------------------------------------------------line-manipulation
, { { "n" }, "<C-S-K>", '"_dd', { desc="Line: delete" } }         -- CTRL+SHIFT+K
, { { "v" }, "<C-S-K>", '"_d',  { desc="Line: delete" } }         -- CTRL+SHIFT+K
, { { "i" }, "<C-S-K>", [[<CMD>normal "_ddgi<CR>]], { desc="Line: delete" } }   -- CTRL+SHIFT+K

, { { "n" } ,"<BS>"      ,"<BS><ESC>"     ,{ desc="Line: remove previous char" } }  -- BACKSPACE
, { { "n" } ,"<SPACE>"   ,"a<SPACE><ESC>" ,{ desc="Line: insert whitespace" } }  -- SPACEW
, { { "n" } ,"<ENTER>"   ,"o"             ,{ desc="Line: new" } } -- ENTER
, { { "n" } ,"<C-ENTER>" ,"O"             ,{ desc="Line: new upwards" } } -- SHIFT+ENTER
, { { "i" } ,"<C-ENTER>" ,"<CMD>normal O<CR>"        ,{ desc="Line: new upwards" } } -- SHIFT+ENTER

-- Removal of a word separated by space or puncutation
-- CTRL +DEL/BS- Remove space-separated world
-- SHIFT+DEL/BS- Remove punct-separated world
-- E[27;2;8  -      SHIFT+BS
-- E[27;6;8  - CTRL+SHIFT+BS
-- RESET:
, { { "i", "c", "n", "v"  } ,"E[27;2;8~", "<NOP>" ,{ desc="" } }
, { { "i", "c", "n", "v"  } ,"E[27;6;8~", "<NOP>" ,{ desc="" } }

, { { "i" }, "<C-Del>"		,[[<CMD>normal "_dwgi<CR>]]			, { desc="Line: remove next word (see 'iskeyword')" } } -- i_CTRL+DEL
, { { "i" }, "<S-Del>"		,[[<CMD>normal <S-Right>"_dgi<CR>]]	, { desc="Line: remove next WORD (see 'iskeyword')" } } --i_CTRL+DEL
, { { "i" }, "<C-H>"		,[[ <CMD>normal "_dba<CR>]]			, { desc="Line: remove previous word (see 'iskeyword')" } } --i_CTRL+BACKSPACE
, { { "i" }, "E[27;2;8~"	,[[ <CMD>normal "_dba<CR>]]			, { desc="Line: remove previous WORD (see 'iskeywotc.)" } } --i_SHIFT+BACKSPACE

, { { "n" },"<C-Del>"		,[[<"_dw]]			,{ desc="Line: remove previous word (see 'iskeywotc.)" } } -- n_SHIFT+BACKSPACEE
, { { "n" },"<S-Del>"		,[[<Right>v<S-Right>"_d]]			,{ desc="Line: remove previous WORD (see 'iskeywotc.)" } } -- n_CTRL+SHIFT+BACKSPACE
, { { "n" }, "<C-H>"		,[[v<Right><C-Left>"_d]]			,{ desc="Line: remove previous word (see 'iskeywotc.)" } } -- n_CTRL+ACKSPACE
, { { "n" }, "E[27;2;8~"	,[[v<Right><S-Left>"_d]]			,{ desc="Line: remove previous WORD (see 'iskeywotc.)" } } -- n_SHIFT+BACKSPACE

-- Shifting selection left/right
-- TODO: [May 24, 2023] Replace by navigation like wincmd w?
, { { "n" },   "<TAB>" , ">>"   ,{ desc="Line: shift to the right" } } -- TAB
, { { "n" }, "<S-TAB>" , "<<"   ,{ desc="Line: shift to the left"  } } -- SHIFT+TAB
-- Delete previous tab
-- , { { "v" },   "<TAB>" , function() if not require("cmp").visible() then vim.cmd(">gv") end end  ,{ desc="Line: shift to the right " } } -- TAB
-- , { { "v" }, "<S-TAB>" , function() if not require("cmp").visible() then vim.cmd("<gv") end end  ,{ desc="Line: shift to the left  "  } } -- SHIFT+TAB

, { { "v" },   "<TAB>" , ">gv" ,{ desc="Line: shift to the right " } } -- TAB
, { { "v" }, "<S-TAB>" , "<gv" ,{ desc="Line: shift to the left  "  } } -- SHIFT+TAB

-- , { { "n", "v" }, "cw" , "ciw" ,{ desc="Line: replace a word under cursor"  } } -- SHIFT+TAB

-- Duplicate lines
, { { "v" }, "<C-S-A-UP>"	,"<CMD>VisualDuplicate -1<CR>" , { desc="Line block: duplicate up" } } -- CTRL+SHIFT+ALT+UP
, { { "v" }, "<C-S-A-DOWN>"	,"<CMD>VisualDuplicate +1<CR>" , { desc="Line block: duplicate down" } } -- CTRL+SHIFT+ALT+DOWN
, { { "n" }, "<C-S-A-UP>"   ,"<CMD>LineDuplicate -1<CR>" , { desc="Line: duplicate up"   } } -- CTRL+SHIFT+ALT+DOWN
, { { "n" }, "<C-S-A-DOWN>" ,"<CMD>LineDuplicate +1<CR>" , { desc="Line: duplicate down" } } -- CTRL+SHIFT+ALT+DOWN
, { { "i" }, "<C-S-A-UP>"   ,"<CMD>normal yy<CR><CMD>put<CR><CMD>normal gi<CR><Up>" , { desc="Line: duplicate up" } } -- CTRL+SHIFT+ALT+DOWN
, { { "i" }, "<C-S-A-DOWN>" ,"<CMD>normal yy<CR><CMD>put<CR><CMD>normal gi<CR><Down>"     , { desc="Line: duplicate down" } } -- CTRL+SHIFT+ALT+DOWN

---------------------------------------------------------------------navigation
, { { "n" }, "<S-ENTER>", ""   , { desc="Line: scroll page (disabled)" } } -- SHIFT+ENTER
--
--Scrolling
, { { "n", "v" }, "<C-U>", "<NOP>" ,{ desc="Buffer: scroll up  " } } -- Disabled
, { { "n", "v" }, "<C-D>", "<NOP>" ,{ desc="Buffer: scroll down" } } -- Disabled

, { { "n", "v" }, "<C-Up>"  , "<C-Y>", { desc="Buffer: scroll up  " } } -- CTRL+UP - Scroll up
, { { "n", "v" }, "<C-Down>", "<C-E>", { desc="Buffer: scroll down" } } -- CTRL+DOWN - Scroll down

, { { "n", "v" }, "<C-k>"  , "<C-Y>", { desc="Buffer: scroll up  " } } -- H+UP - Scroll up
, { { "n", "v" }, "<C-j>"  , "<C-E>", { desc="Buffer: scroll down" } } -- J+DOWN - Scroll down
, { { "n", "v" }, "<C-j>"  , "<C-E>", { desc="Buffer: scroll down" } } -- J+DOWN - Scroll down
, { { "i" }, "<C-Up>"   , "<ESC><C-Y>gi", { desc="Buffer: scroll up  " } }
, { { "i" }, "<C-Down>" , "<ESC><C-E>gi", { desc="Buffer: scroll down" } }

, { { "n" }, "<mC-w>gf"  , ":tab drop fnameescape(expand('<cfile>'))<CR>", { desc="Buffer: jumpt to a file under cursor" } }

-- TODO: [April 19, 2023] Replce GF with newtab command!
-- , { { "n" }, "gf"		, ":tab drop fnameescape(expand('<cfile>'))<CR>", { desc="Buffer: jumpt to a file under cursor" } }
-- vim.cmd("abbreviate gf :tab drop fnameescape(expand('<cfile>'))<CR>")
-- Buffer: jump to start/middle/end

-------------------------------------------------------------------------window

-- , { { "v", "n" }, ""             , "<ESC><M>gi" ,{ desc="Buffer: jump to the middle of the window" } }

, { { "n" }, "<C-N>",  function()
		local newvim = vim.fn.system("xterm -fs 10 -fa 'JetBrainsMono Nerd Font Mono' -e nvim & disown")
		-- local newvim = vim.system({ "nvim-x" }, { text = true, detach = true })
	end
	,{ desc="Workspace: new window"    }

	}
, { { "v", "n" }, "<C-S-Home>", "<S-H>"              ,{ desc="Buffer: move cursor to the top of the window"    } }
, { { "v", "n" }, "<C-S-End>" , "<S-L>"              ,{ desc="Buffer: move cursor to the bottom of the window" } }
-- , { { "v", "n" }, "E[1;6H", [[echo  CTRL+HOM is hit]] ,{ desc="Buffer: jump to the bottom of the window" } }
-- , { { "v", "n" }, "E[1;6F", [[echo  CTRL+END is hit]] ,{ desc="Buffer: jump to the bottom of the window" } }


, { { "v" }, "<C-A>", "<ESC><C-A>"          ,{ desc="Buffer: select all text" } } -- CTRL+A
, { { "n" }, "<C-A>", "0ggv<C-End>"         ,{ desc="Buffer: select all text" } } -- CTRL+A

, { { "n" }, "<A-Left>"    , "<C-O>"        ,{ desc="Jumplist: jump to prev cursor pos" } } -- ALT+LEFT
, { { "n" }, "<A-Right>"   , "<C-I>"        ,{ desc="Jumplist: jump to next cursor pos" } } -- ALT+RIGHT
, { { "i" }, "<A-Left>"    , "<ESC><C-O>gi" ,{ desc="Jumplist: jump to prev cursor pos" } } -- ALT+LEFT
, { { "i" }, "<A-Right>"   , "<ESC><C-I>gi" ,{ desc="Jumplist: jump to next cursor pos" } } -- ALT+RIGHT

------------------------------------------------------------------------history
-- Win32-style shortcuts
, { { "n", "v" }, "<C-S>" ,":update<CR><ESC>"   ,{ desc="File: save" } } -- CTRL+S
, { { "i"      }, "<C-S>" ,"<ESC>:update<CR>gi" ,{ desc="File: save" } } -- CTRL+S

, { { "i" }, "<C-Z>", "<ESC>:undo<CR>gi", { desc="History: undo" } } -- CTRL+Z
, { { "i" }, "<C-S-Z>", "<ESC>:redo<CR>gi", { desc="History: redo" } } -- CTRL+SHIFT+Z

, { { "n", "v" }, "<C-Z>", ":undo<CR>", { desc="History: undo" } } -- CTRL+Z
, { { "n", "v" }, "<C-S-Z>", ":redo<CR>", { desc="History: redo" } } -- CTRL+SHIFT+Z
, { { "n", "v" }, "<C-S-Z>", function() vim.cmd "redo" end, { desc="History: redo" } } -- CTRL+SHIFT+Z

--nvim-tree-lua
-- , { { "n", "v" }, "<M-1>", ":NvimTreeToggle<CR><ESC>", { desc="File: explorer: toggle (nvim-tree)" } } -- ALT+1
, { { "n", "v" }, "<M-1>", function() require("nvim-tree.api").tree.focus() end , { desc="File: explorer: focus (nvim-tree)" } } -- ALT+1
--[[, { { "n", "v" }, "<M-1>", function()
    print(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
end, { desc="File: explorer: toggle (nvim-tree)" } } -- ALT+1]]
---------------------------------------------------------------------completion
-- , { { "i" }, "<C-Space>", "<C-X><C-O>", { desc="Buffer: show completion prompt (omnifunction)" } }

, { { "n", "v", "i", "x" }, ":mksession!<CR>", nil, { desc="Session: save (force)" } }
, { { "n", "v", "i", "x" }, ":source Session.vim<CR>", nil, { desc="Session: restore (force)" } }

-------------------------------------------------------------------------motions
-- TODO: [September 03, 2023] Add new motion
, { { "v" }, "al" ,"<ESC>g^vg_", { desc="buffer: select inner sentence" } }
, { { "n" }, "yal" ,"g^vg_y", { desc="buffer: copy/yank inner sentence" } }
-- , { { "o" }, "al" ,"g^g_", { desc="Editor: motion: inner sentence" } }
-- , { { "v" }, "al" ,"normal g^ g_", { desc="Editor: motion: inner sentence" } }

} -- Keybindings END


M.keymaps = vim.list_extend(M.keymaps, {
	  { { "n", "v" }, "E[3;5~" ,"za", { desc= "Buffer: fold toggle recursively" } }
	, { { "n", "v" }, "zl", "zr", { desc="Buffer: fold less" } }
	, { { "n", "v" }, "zL", "zR", { desc="Buffer: fold less all" } }
	, { { "n", "v" }, "zm", nil , { desc="Buffer: fold more" } }
	, { { "n", "v" }, "zM", nil , { desc="Buffer: fold more all" } }
})


---------------------------------------------------------------------------tabs
M.keymaps = vim.list_extend(M.keymaps,{
	  { { "n" }, "<C-T>", "<Cmd>tabnew<CR>" }
	, { { "n", "v", "i", "x" }, "<F28>", "<Cmd>:bdelete!<CR>" } -- CTRl+F4
	-- If the same file is opened in multiple windows then
	-- , { { "n", "i", "v" }, "<C-W>c",function()
	-- 		 vim.cmd("<Cmd>:bdelete<CR>")
	-- 	end, { desc="Buffer: delete/close" } }    -- CTRL+W+C
	, { { "n", "i", "v" }, "<C-W>q", "<Cmd>:bdelete<CR>",{ desc="Window: close file's window[s] and delete buffer" } }    -- CTRL+W+Q

	, { { "n", "v" }, "E[5;6~", function()
		local tabs      = vim.api.nvim_list_tabpages()
		local currentTab = vim.api.nvim_get_current_tabpage()
		local isFirst   = tabs[1] == currentTab

		print(("debug: %s: { tabs, currentTab }"):format(debug.getinfo(1).source))
		print(vim.inspect({ tabs, currentTab }))

		if isFirst then
			vim.cmd([[tabmove]])
		else
			vim.cmd([[tabmove -1]])
		end
	end, { desc= "Tabs: move to the left" } }  -- CTRL+SHIFT+PGUP

	, { { "n", "v" }, "E[6;6~", function()
		local tabs      = vim.api.nvim_list_tabpages()
		local currentTab = vim.api.nvim_get_current_tabpage()
		local isLast    = tabs[#tabs] == currentTab

		print(("debug: %s: { tabs, currentTab }"):format(debug.getinfo(1).source))
		print(vim.inspect({ tabs, currentTab }))

		if isLast then
			vim.cmd([[0tabmove]])
		else
			vim.cmd([[tabmove +1]])
		end
	end, { desc= "Tabs: move to the right" } }  -- CTRL+SHIFT+PGUP
})

-- CTRL-0 to switch tab
M.keymaps = vim.list_extend(M.keymaps,{
	{ { "n", "v", "i", "s", "x" }, "<C-0>", function()
		-- This is telescope-independent way to switch tabs
		local tabs      = vim.api.nvim_list_tabpages()
		local currentTab = vim.api.nvim_get_current_tabpage()
			  vim.ui.input({
			  prompt = ("Enter tab number (%s): "):format(#tabs)
			, default = currentTab
			}, function(input)
				if input then
					vim.cmd([[tabnext ]] .. input)
				else
					vim.notify("CTR-0 aborted", vim.log.levels.INFO)
				end
			end)
	end, { desc="Tabs: focus tab N" } } --CTRL+0
})

-- Setup CTRL-1 ... CTRL-9 keybindings
for i = 1, 9 do
	local keymap = 	{
		{ "n", "v", "i", "s", "x" }, "<C-" .. i .. ">"
		, function()
			local tabs = vim.api.nvim_list_tabpages()
			if i <= #tabs then
				vim.cmd([[tabnext ]] .. i)
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
	for i=1,#keymaps do
			local mode = keymaps[i][1]
			local key  = keymaps[i][2]
			local cmd  = keymaps[i][3]
			local opt  = keymaps[i][4]
			-- print(mode, key, cmd, opt and opt.desc)
			-- If command is nil, then don't add shortcut
			local ok = cmd and vim.keymap.set(mode, key, cmd, opt)
			return ok
	end

end

M.legendary = {}
M.legendary.keymaps = M.keymaps

--- @brief I initialize keybinings either via built-in API or by Plugin
M.legendary.init = function(self, legendary)
        local keymaps = self.keymaps
        if legendary and legendary.keymaps then
                -- Conver to Legendary-friendly entry
                for i=1,#keymaps do
                        -- Convert to full description field
                        local   entry = keymaps[i]
                        -- local   eKeyMap={}
                        entry.mode = entry[1];
                        entry[1] = entry[2] -- shortcut
                        entry[2] = entry[3] -- command
                        if entry[4] then
                                entry.description = entry[4].desc;
                                entry[4].desc = nil;
                                entry.opts=entry[4];
                                entry[3]=nil
                        end
                end
				-- -Legendary plugin requires methods and extra fields removed
				keymaps = vim.list_slice(keymaps, 1, #keymaps)
				legendary.keymaps(keymaps)
        end
		return self
end

return M
