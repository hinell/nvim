--- @diagnostic disable: redefined-local
--- @diagnostic disable: lowercase-global
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local M = {}

-- # nvim-tree
-------------------------------------------------nvim-tree-close-after-last-tab
-- A script to close nvim after last tab is closed
-- Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
---@diagnostic disable-next-line: unused-function
local function tab_win_closed(winnr)
  local api      = require("nvim-tree.api")
  local tabnr    = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr    = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

M.legendary = {}
M.legendary.funcs = {
	{
		description = "Editor: nvim-tree: focus in file explorer", function()
			local nvimTree = require("nvim-tree.api")
			local tab = vim.api.nvim_get_current_tabpage()
			-- local buf = vim.api.nvim_get_current_buf()
			-- local bufPath = vim.api.nvim_buf_get_name(buf)
			nvimTree.tree.find_file({ open = true, focus = true })
		end }
	}

M.shada_exclude = {}
M.shada_exclude_config = function()
	autocmd({
		"FileType"
	},{
		pattern  = "NvimTree",
		group    = "NvimTreeBufferLocal",
		callback = function(auEvent)
			local bufnr = auEvent.buf
			local tabCurrent = vim.api.nvim_get_current_tabpage()
			local bufName    = vim.api.nvim_buf_get_name(bufnr)

			if not (M.shada_exclude[tabCurrent] and bufName == "" ) then
				M.shada_exclude[tabCurrent] = bufName
				vim.opt.shada:append("r" .. bufName)
				-- print(("%s: shada updated with %s"):format(debug.getinfo(1).source, bufName))
			end
		end
	})

end

M.pm = {}
M.pm.config = function()
	-- CONTINUE: [December 01, 2023] Replace nvim-tree by neo-tree
	-- disable netrw at the very start of your init.lua (strongly advised)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	local apiOk, api = pcall(require, "nvim-tree.api")
	if not apiOk then
		vim.notify("nvim-tree.api module is not found", vim.log.levels.INFO)
		return
	end

	augroup("NvimTreeBufferLocal", { clear = true })
	M.shada_exclude_config()

	if apiOk then
		-- Create file upon
		api.events.subscribe(api.events.Event.FileCreated, function(file)
		  vim.cmd("tabnew " .. file.fname)
		  api.tree.open()
		end)
	end

	local config = {}

	config.select_prompts = true
	config.log = {}
	config.log.enable = true
	config.log.types = {}
	config.log.types.git = true
	config.log.types.action_git = true

	config.diagnostics = {}
	config.diagnostics.enable = true
	config.diagnostics.show_on_dirs = false

	-- config.open_on_setup_file = false,
	config.sort_by = "case_sensitive"
	config.sync_root_with_cwd = true
	config.open_on_tab = false

	config.actions = {}
	config.actions.use_system_clipboard = true

	config.view = {}
	config.view.adaptive_size = false
	config.view.side = "right"
	config.view.width = 52

	config.renderer = {}
	config.renderer.group_empty = true

    config.renderer.special_files = {
		"Cargo.toml",
		"Makefile", "CMakeLists.txt",
		"config.bash", "config.sh", "config",
		"README.md", "readme.md", "LICENSE", "DEVELOPMENT.md", "DEVELOPING.md",
		"package.json", ".nvimrc"
	}
	config.renderer.highlight_git          = true
	config.renderer.highlight_diagnostics  = true
	-- config.renderer.highlight_opened_files = "none"
	-- config.renderer.highlight_modified     = "none"
	config.renderer.highlight_bookmarks    = "all"
	config.renderer.highlight_clipboard    = "all"

	config.renderer.icons = {}
	config.renderer.icons.webdev_colors = false
	config.renderer.icons.git_placement = "after"
	config.renderer.icons.modified_placement = "after"
	config.renderer.icons.glyphs = {
		git = {
			-- Git style symbols
			unstaged  = "U",
			staged    = "A",
			unmerged  = "M",
			renamed   = "R",
			untracked = "?",
			deleted   = "D",
			ignored   = "!"
		}
	}

	config.filters = {}
	config.filters.dotfiles = false
	config.filters.custom = {}

	config.git = {}
	config.git.enable = true
	-- config.git.timeout = 5000
	-- DO NOT COMMENT - This removes default keymaps
	config.on_attach = function(bufnr)
	-- Moved to autocmd below
	end


	require("nvim-tree").setup(config)

	local nvimTreeSetupKeymapsFn = function(auEvent)
		local bufnr        = auEvent.buf
		-- Prevent from adding keymaps twice
		if vim.b.nvimTreeKeymapsSet then return end
		vim.b.nvimTreeKeymapsSet = true
		-- print(("%s: nvim-tree keymap must be set"):format(debug.getinfo(1).source, vim.b.nvimTreeKeymapsSet))

		local apiOk, api = pcall(require, "nvim-tree.api")
		assert(apiOk, "nvim-tree api.lua module is not found!")

		-- Borrowed directly from nvim-tree internal api.lua

		-- Custom extension - do not collapse opeend buffers
		api.tree.collapse_all_keep = function()
			return api.tree.collapse_all(true)
		end

		-- Set up Legendary plugin keybindigns
		local function opts(desc, opts)
			opts = opts or {}
			return vim.tbl_extend("keep", opts, {
				-- desc = "nvim-tree: " .. desc,
				desc = desc,
				buffer = bufnr,
				noremap = true,
				silent = true,
				nowait = true,
			})
		end

		local keymap_disable = function (message)
			return function()
				message = message or ""
				vim.notify(("%s%s"):format("hinell config: keymap disabled", message), vim.log.levels.INFO)
			end
		end
		keymap_disable()
		-- LuaFormatter off
		-- NOTE: These bindings may fail if api changes
		local nvimTreeKeymap = {
			-- TODO: [November 26, 2023] Propose to convert marks into a global clipboard
			-- { mode = { "n" }, "bd" , api.marks.bulk.delete, opts = opts("delete bookmarked") },
			-- { mode = { "n" }, "bt" , api.marks.bulk.trash , opts = opts("trash bookmarked") },
			-- { mode = { "n" }, "bmv", api.marks.bulk.move  , opts = opts("move bookmarked") },
			-- { mode = { "n" }, "m"  , api.marks.toggle     , opts = opts("toggle bookmark") },

			{ mode = { "n" }, "<S-k>"        , api.node.show_info_popup          , opts = opts("info") },
			{ mode = { "n" }, "<BS>"         , api.node.navigate.parent_close    , opts = opts("navigate: close directory") },
			{ mode = { "n" }, "[c"           , api.node.navigate.git.prev        , opts = opts("navigate: prev git change") },
			{ mode = { "n" }, "]c"           , api.node.navigate.git.next        , opts = opts("navigate: next git change") },
			{ mode = { "n" }, ">"            , api.node.navigate.sibling.next    , opts = opts("navigate: next sibling") },
			{ mode = { "n" }, "<"            , api.node.navigate.sibling.prev    , opts = opts("navigate: previous sibling") },
			-- { mode = { "n" }, "K"            , api.node.navigate.sibling.first   , opts = opts("navigate: first sibling") },
			-- { mode = { "n" }, "J"		      , api.node.navigate.sibling.last    , opts = opts("navigate: last sibling") },
			{ mode = { "n" }, "P"	         , api.node.navigate.parent          , opts = opts("navigate: parent directory") },
			{ mode = { "n" }, "<C-]>" 		 , api.tree.change_root_to_node      , opts = opts("tree: cd into folder") },
			-- { mode = { "n" }, "<C-[>"  		 , api.tree.change_root_to_parent    , opts = opts("tree: cd root to parent") },
			{ mode = { "n" }, "<C-[>"  		 , keymap_disable(" (CTRL+[ is the same as ESC)")    , opts = opts("tree: cd root to parent") },
			{ mode = { "n" }, "[d"           , api.node.navigate.diagnostics.prev, opts = opts("navigate: diagnostics: go to prev" ) },
			{ mode = { "n" }, "]d"           , api.node.navigate.diagnostics.next, opts = opts("navigate: diagnostics: go to prev" ) },
			{ mode = { "n" }, "."            , api.node.run.cmd                  , opts = opts("run nvim command") },
			{ mode = { "n" }, "os"           , api.node.run.system               , opts = opts("open file by system default app") },
			{ mode = { "n" }, "<C-e>"        , api.node.open.replace_tree_buffer , opts = opts("open: in place / last buffer") },
			{ mode = { "n" }, "<C-o>t"       , api.node.open.tab                 , opts = opts("open: new tab") },
			{ mode = { "n" }, "<C-o>v"       , api.node.open.vertical            , opts = opts("open: vertical split") },
			{ mode = { "n" }, "<C-o>s"       , api.node.open.horizontal          , opts = opts("open: horizontal split") },
			{ mode = { "n" }, "<CR>"         , api.node.open.tab_drop            , opts = opts("open") },
			{ mode = { "n" }, "<tab>"        , api.node.open.preview             , opts = opts("open preview") },
			{ mode = { "n" }, "O"            , api.node.open.no_window_picker    , opts = opts("open: no window picker") },
			{ mode = { "n" }, "o"            , api.node.open.edit                , opts = opts("open") },

			{ mode = { "n" }, "<2-LeftMouse>", api.node.open.tab_drop, opts = opts("file: open") },

			{ mode = { "n" }, "<C-S-F>", api.live_filter.clear, opts = opts("find: filter: clean") },
			{ mode = { "n" }, "<C-f>"  , api.live_filter.start, opts = opts("find: filter") },

			{ mode = { "n" }, "g?"    , api.tree.toggle_help            , opts = opts("tree: help") },
			{ mode = { "n" }, "vB"    , api.tree.toggle_no_buffer_filter, opts = opts("tree: toggle view filter: no buffer") },
			{ mode = { "n" }, "vG"    , api.tree.toggle_git_clean_filter, opts = opts("tree: toggle view filter: git clean") },
			{ mode = { "n" }, "vI"    , api.tree.toggle_gitignore_filter, opts = opts("tree: toggle view filter: git ignore") },
			{ mode = { "n" }, "vD"    , api.tree.toggle_hidden_filter   , opts = opts("tree: toggle view filter: dotfiles") },
			{ mode = { "n" }, "vU"    , api.tree.toggle_custom_filter   , opts = opts("tree: toggle view filter: hidden") },
			{ mode = { "n" }, "q"     , vim.cmd.bwipeout                , opts = opts("tree: close pane") },
			{ mode = { "n" }, "<C-w>q", vim.cmd.bwipeout                , opts = opts("tree: close pane") },
			{ mode = { "n" }, "R"     , api.tree.reload                 , opts = opts("tree: refresh") },
			{ mode = { "n" }, "S"     , api.tree.search_node            , opts = opts("tree: search node by path") },
			{ mode = { "n" }, "E"     , api.tree.expand_all             , opts = opts("tree: unfold / expand all trees") },
			{ mode = { "n" }, "W"     , api.tree.collapse_all_keep      , opts = opts("tree: fold / collapse all trees") },
			{ mode = { "n" }, "<2-rightmouse>", api.tree.change_root_to_node     , opts = opts("tree: cd") },
			{ mode = { "n" }, "w" , function() api.tree.collapse_all(true) end, opts = opts("tree: collapse with focused buffer folder open")  },

			-- FileSystem actions
			{ mode = { "n" }, "a"    , api.fs.create            , opts = opts("path: create / add") },
			{ mode = { "n" }, "c"    , api.fs.copy.node         , opts = opts("file: copy into a clipboard") },
			-- { mode = { "n" }, "d"    , api.fs.remove            , opts = opts("file: delete") },
			{ mode = { "n" }, "D"    , api.fs.trash             , opts = opts("file: trash") },
			{ mode = { "n" }, "yf"   , api.fs.copy.filename     , opts = opts("file: copy filename") },
			{ mode = { "n" }, "yr"   , api.fs.copy.relative_path, opts = opts("file: copy relative filepath") },
			{ mode = { "n" }, "ya"   , api.fs.copy.absolute_path, opts = opts("file: copy absolute filepath") },
			-- { mode = { "n" }, "p"    , api.fs.paste             , opts = opts("file: paste") },
			-- { mode = { "n" }, "r"    , api.fs.rename            , opts = opts("file: rename") },
			-- { mode = { "n" }, "e"    , api.f  s.rename_basename   , opts = opts("file: rename: basename") },
			-- { mode = { "n" }, "u"    , api.fs.rename_full       , opts = opts("file: rename: full path") },
			-- { mode = { "n" }, "x"    , api.fs.cut               , opts = opts("file: cut") },
			-- { mode = { "n" }, "<c-r>", api.fs.rename_sub        , opts = opts("file: rename: omit filename") },
		}

		nvimTreeKeymap = vim.list_extend(nvimTreeKeymap, {
			-- Git fs actions
			{ mode = { "n" }, "x"     , api.git.cut            , opts = opts("git: file: cut file into clipboard") },
			{ mode = { "n" }, "p"     , api.git.paste          , opts = opts("git: file: past file from clipboard") },
			{ mode = { "n" }, "d"     , api.git.delete         , opts = opts("git: file: delete") },
			{ mode = { "n" }, "rf"    , api.git.rename         , opts = opts("git: file: rename filename") },
			{ mode = { "n" }, "rr"    , api.git.rename_relative, opts = opts("git: file: rename relative path") },
			{ mode = { "n" }, "rb"    , api.git.rename_basename, opts = opts("git: file: rename basename") },
			{ mode = { "n" }, "ra"    , api.git.rename_absolute, opts = opts("git: file: rename absolute path") },
			{ mode = { "n" }, "rd"    , api.git.rename_sub     , opts = opts("git: file: rename basedir" ) },
			-- Not implemented
			-- { mode = { "n" }, "<C-r>u", api.git.history_undo   , opts = opts("git: rename: undo last rename") }

		})
		-- LuaFormatter on

		-- ,{ { "n", "v" }, "<M-1>", function()
		-- 	print(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
		-- end, { desc="File: explorer: toggle (nvim-tree)" } } -- ALT+1

		local legendaryIsOk, legendary = pcall(require, "legendary")
		if legendaryIsOk then
			require("legendary").keymaps({
				{
					itemgroup = "File explorer",
					description = "File: explorer: nvim-tree local keymaps",
					keymaps = nvimTreeKeymap
				}
			})
		end

	end


	local legendaryIsOk, legendary = pcall(require, "legendary")
	if not legendaryIsOk then return end


	--nvim-tree-lua
	local nvimTreeKeymapAlt1 = {
		mode = { "n", "i" ,"v" }, "<M-1>", function(event)
			local nvimTree = require("nvim-tree.api")
			local tab = vim.api.nvim_get_current_tabpage()
			local buf = vim.api.nvim_get_current_buf()
			local bufFt = vim.api.nvim_get_option_value("filetype", { buf = buf })
			local bufPath = vim.api.nvim_buf_get_name(buf)

			if bufFt == "NvimTree" then
				nvimTree.tree.toggle()
				vim.t[tab].nvim_tree_focused_current = false
			else
				if vim.t[tab].nvim_tree_focused_current then
					nvimTree.tree.focus()
				else
					nvimTree.tree.find_file({ open = true, focus = true, path = bufPath, updateRoot = false })
					vim.t[tab].nvim_tree_focused_current = true
				end
			end
		end , opts = { desc="File: explorer: focus (nvim-tree)" }
	} -- ALT+1

	legendary.keymap(nvimTreeKeymapAlt1)
	legendary.funcs(M.legendary.funcs)

	-- legendary.funcs({
	-- 	{
	-- 		itemgroup="File explorer",
	-- 		funcs = M.legendary.funcs
	-- 	}
	-- })

	autocmd({
		"FileType"
	},{
		pattern  = "NvimTree",
		once     = false,
		group    = "NvimTreeBufferLocal",
		callback = nvimTreeSetupKeymapsFn
	})

end

M.init = function(self, pm)
	local use = pm.use
	use({
		"hinell/nvim-tree.lua",
		disabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		after    = "nvim-web-devicons",
		opt      = false,
		config   = self.pm.config
	})

end

return M
