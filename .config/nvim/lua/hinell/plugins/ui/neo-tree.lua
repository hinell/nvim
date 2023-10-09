---@diagnostic disable: redefined-local

local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds
local autocmd = vim.api.nvim_create_autocmd
-- local usercmd = vim.api.nvim_create_user_command

-- Neo-tree plugin configuration
local M = {}
-- NOTE: [March 25, 2023] neo-tree is memory inefficient in huge git projects, DO NOT USE IT

M.legendary = {}
M.legendary.autocmds = {}

M.config = function()

	local auCmdFtCb = function(autoCmdEvent)
		local neoTreeKeymaps = {}
		local function keymapsAdd (keymaps, mappings, keys, prefix, autoCmdEvent)
			for i, k in pairs(keys) do
				local description = mappings[k];
				if type(description) == "table" then
					description = description[1]
				end
				table.insert(keymaps, {
					k,
					mode = "n",
					description = prefix .. description,
					opts = { buffer = autoCmdEvent.buf }
				})
			end
		end
		-- DEBUG: [March 25, 2023] This consumes a lot of memory!

		local maps = require("neo-tree.defaults").window.mappings
		keymapsAdd(neoTreeKeymaps, maps, vim.tbl_keys(maps), "neo-tree: ", autoCmdEvent)

		local mapsfs = require("neo-tree.defaults").filesystem.window.mappings
		keymapsAdd(neoTreeKeymaps, mapsfs, vim.tbl_keys(mapsfs), "neo-tree: fs: ", autoCmdEvent)

		local mapsgit = require("neo-tree.defaults").git_status.window.mappings
		keymapsAdd(neoTreeKeymaps, mapsgit, vim.tbl_keys(mapsgit), "neo-tree: git:", autoCmdEvent)

		print(vim.inspect(neoTreeKeymaps))
		require("legendary").setup({
			keymaps = neoTreeKeymaps
			--[[ keymaps = {
				{ itemgroup="neo-tree: ", keymaps =  neoTreeKeymaps}
			} ]]
		})
	end

	-- augroup("NeoTreeHinell", { clear = true })
	autocmd({
			"FileType"
		},{
			pattern = "neo-tree",
			once     = true,
			group    = "NeoTreeHinell",
			callback = function(auEvent)
				local bufnr = auEvent.buf
				auCmdFtCb(auEvent)
				-- auclear({ group = "NeoTreeHinell" })
			end
	})

	augroup("NeotreeBufferLocal", { clear = true })
	autocmd({
		"WinClosed"
	},{
		pattern  = "neo-tree",
		once     = false,
		group    = "NeotreeBufferLocal",
		description = "Neotree: close when NvimTree is last window",
		-- nested = true,
		callback = function ()
			local winnr = tonumber(vim.fn.expand("<amatch>"))
			-- vim.schedule_wrap(tab_win_closed(winnr))
		  end
	})

end

M.init = function(self, pm)
	local use = pm.use

	use({
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		tag = "3.x",
		desc = "Neovim plugin to manage the file system and other tree like structures.",
		-- branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			local config = {}

			config.window = {}
			config.window.position = "right"
			config.window.width = 40 -- applies to left and right positions
			-- config.window.height = 15 -- applies to top and bottom positions
			config.window.auto_expand_width = false -- expand the window when file exceeds the window width. does not work with position = "float"
			config.window.popup = {}
			config.filesystem = {}

			local fs = {}
			fs.follow_current_file = {}
			fs.follow_current_file.enabled = true
			fs.follow_current_file.enabled = true
			-- fs.follow_current_file.leave_dirs_open = false -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
			config.filesystem = fs

			require("neo-tree").setup(config)
		end
	})

end

return M
