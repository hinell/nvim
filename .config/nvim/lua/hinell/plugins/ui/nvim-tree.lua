local M = {}
-- # nvim-tree
-------------------------------------------------nvim-tree-close-after-last-tab
-- A script to close nvim after last tab is closed
-- Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
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

M.packer = {}
M.packer.config = function()
	-- disable netrw at the very start of your init.lua (strongly advised)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	local apiLoaded, api = pcall(require, "nvim-tree.api")
	assert(apiLoaded, "nvim-tree.api module is not found")

	if apiLoaded then
		-- Create file upon
		api.events.subscribe(api.events.Event.FileCreated, function(file)
		  vim.cmd("tabnew " .. file.fname)
		  print("nvim_buf_get_name => ", vim.api.nvim_buf_get_name(0))
		  api.tree.open()
		end)
	end

	require("nvim-tree").setup({
		actions = {
			use_system_clipboard = true
		},
		log = {
		  enable = false,
		  types = { git = false }
		},
		sort_by = "case_sensitive",
		sync_root_with_cwd = true,
		open_on_tab = false, -- TODO: Open issue to make it new tab
		-- open_on_setup_file = false,
		on_attach = function(bufnr)
			local function opts(desc)
				return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			local apiLoaded, api = pcall(require, "nvim-tree.api")
			assert(apiLoaded, "nvim-tree api.lua module is not found!")

			vim.keymap.set("n", "<CR>", api.node.open.tab_drop, opts("Tab drop"))
		end,
		actions = {
			use_system_clipboard = true
		},
		view = {
			adaptive_size = true,
			side  = "right",
			width = 48,
		},
		renderer = {
		group_empty = true,
		icons = {
			webdev_colors = false,
			git_placement = "after",
			modified_placement = "after",
			glyphs = {
				git = {
					-- Git style symbols
					  unstaged  = "U"
					, staged    = "A"
					, unmerged  = "M"
					, renamed   = "R"
					, untracked = "?"
					, deleted   = "R"
					, ignored   = "!"
				}
			}
		}
		},
		filters = {
			dotfiles = false,
		},
		git = {
		  enable = true,
		  timeout = 300
		},
		-- Disable all keys to be set up by Legendary
		remove_keymaps = keystodisable
	})
end

M.packer.register = function(self, packer)
	local use = packer.use
	use({
		"nvim-tree/nvim-tree.lua",
		disabled = false,
		requires = { "nvim-tree/nvim-web-devicons" },
		after    = "nvim-web-devicons",
		-- tag      = "nightly", -- optional, updated every week. (see issue #1193)
		opt      = false,
		config   = self.config
	})

end

-- Config for Legendary plugin
M.legendary = {}
M.legendary.autocmds = {
	{
	  "WinClosed",
	  description = "Nvim tree: close when NvimTree is last window",
	  function ()
		local winnr = tonumber(vim.fn.expand("<amatch>"))
		-- vim.schedule_wrap(tab_win_closed(winnr))
	  end,
	  nested = true
	},
	{
		"FileType",
		-- Fixed in recent versions
		-- description = "Embed NvimTree shortcuts for Legendary",
		opts = { pattern = "NvimTree" },
		function(autoCmdEvent)
				-- Prevent from adding keymaps twice
				if vim.b.nvimTreeKeymapsSet then return end
				vim.b.nvimTreeKeymapsSet = true

				local ok, api = pcall(require, "nvim-tree.api")
				assert(ok, "nvim-tree api.lua module is not found!")

				api.config.mappings.default_on_attach(autoCmdEvent.buf)
				assert(api.config.mappings.get_keymap_default, string.format("[[%s]]: %s ", "hinell-plugins-nvim-tree.lua", "get_keymap_default is not found"))
				if api.config.mappings.get_keymap_default then
					-- This reflects on changes in:
					-- https://github.com/nvim-tree/nvim-tree.lua/issues/1858#issuecomment-1467132602
					nvimtreemappings = api.config.mappings.get_keymap_default()
				end

				-- local   keystodisable    = vim.tbl_map(function(e) return e.key end, nvimtreemappings)
				-- Set up Legendary plugin keybindigns
				local keymaps = vim.tbl_map(function(e)

					-- just set up a description-only keymap
					local entry = {}
					entry.mode  = "n"
					entry[1]    = e.lhs or e.key        -- Key
					if type(e.key) == "table" then entry[1] = e.key[1] end
					local prefix = ""
					local nvimTreeReg = "nvim%-tree"
					if not string.match(e.desc, nvimTreeReg) then
						prefix = "nvim-tree: "
					end
					entry.description = prefix .. e.desc
					entry.opts = { buffer = autoCmdEvent.buf--[[ , noremap = true  ]]}

					return entry
				end, nvimtreemappings)

				require("legendary").setup({
					keymaps = keymaps
					--[[ keymaps = {
						{ itemgroup="Nvim-tree: ", keymaps = keymaps }
					} ]]
				})
		end
	}
}

M.legendary.init = function(self, legendary)
	legendary.autocmds(self.autocmds)
end

return M
