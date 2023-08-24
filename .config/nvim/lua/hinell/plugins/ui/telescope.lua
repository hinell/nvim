-- @module hinell-plugins-telescope

require("hinell.std")

-- This function is intended for to be used for Telescope pickers
--- @usage  telescope.ext.pick({  attach_mappings = telescopeTabDrop })
local telescopeTabDrop = function(_, map)
	  map({ "i", "n" }, "<CR>", require("telescope.actions").select_tab_drop)
	  return true
	end

local M = {}

M.packer = {}
M.telescope = {}

M.packer.config = function()

	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	local themes  = require("telescope.themes")
	local inserPathPluginIsOk, inserPathPlugin = assert(pcall(require, "telescope_insert_path"))

	local config  = {
		-- uniq_string
		defaults = {
			border   = true,
			mappings = {
				n = {
					["."] = inserPathPluginIsOk and inserPathPlugin.insert_relpath_a_insert or nil
				}
			},
			hidden = true
		},
		extensions = {
			-- NOTE: Setting mappings should be supporte with my PR
			-- https://github.com/benfowler/telescope-luasnip.nvim/pull/19
			luasnip = {
				border = true,
				preview = {
					check_mime_type = false
				}
				-- layout_config = {
				-- 	height = 24,
				-- 	width  = 191
				-- }
			},
			fzf = {
			  fuzzy = true,
			  override_generic_sorter = true,
			  override_file_sorter = true,
			  case_mode = "smart_case",
			},
			["ui-select"] = {}
		}
	}

	-- Pickers config
	config.pickers = {
		buffers = {
			mappings = {
				i = {
					["<CR>"] = actions.select_tab_drop
				},
				n = {
					["<DEL>"]= function()
						-- TODO: [Friday, January 13, 2023] Map <del> for unlisted buffers removal
						local action_state = require "telescope.actions.state"
						print("Delete buffer")
					end
				}
			}
		}
		-- LuaFormatter off
		,	find_files	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		,	git_files	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		,	old_files	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
	 	,	live_grep	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		,	grep_string	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		-- LuaFormatter on
	}
	-- Set up pickers for all lsp_* builtins
	-- NOTE: we don't need to do this for every builtin, as some may misbehave
	for k,v in pairs(builtin) do
		if k:match("lsp_") then
			config.pickers[k] = { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		end
	end

	require("telescope").setup(config)
end

M.packer.register = function(self, packer)
	local use = packer.use
	use({
		-- This config should come before extensions
		"nvim-telescope/telescope.nvim"
		, requires = {
				"nvim-lua/plenary.nvim",
				"kiyoon/telescope-insert-path.nvim"
		}
		,	config = self.config
	})

	local use = packer.use
	use({
		"nvim-telescope/telescope-fzf-native.nvim"
		, run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
		, requires = {
			"nvim-telescope/telescope.nvim"
		}
		, run = "make"
		, config = function()
			require("telescope").load_extension("fzf")
		end
	})

	use({
		"smartpde/telescope-recent-files"
		, requires = {
			"nvim-telescope/telescope.nvim"
		}
		, config = function() require("telescope").load_extension("recent_files") end
	})

	use({
		"olacin/telescope-cc.nvim"
		, requires = {
			"nvim-telescope/telescope.nvim"
		}
		, config = function()
			require("telescope").load_extension("conventional_commits")
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				legendary.keymap({
					mode = { "n" }
					, description = "Workspace: git: commit staged changes (cc)"
					, "<CMD>Telescope conventional_commits<CR>"
				})
			end
		end
	})

	use({
		-- TODO: [April 28, 2023] Fix the default action
		-- TODO: [May 12, 2023] Make Todo search local todos!
		 "folke/todo-comments.nvim"
		, requires = "nvim-lua/plenary.nvim"
		, config = function()
			-- TodoQuickFix lua require("todo-comments.search").setqflist(<q-args>)
			-- TodoLocList lua require("todo-comments.search").setloclist(<q-args>)
			-- TodoTelescope Telescope todo-comments todo <args>
			-- TodoTrouble Trouble todo <args>
			require("todo-comments").setup({
				keywords = {
					-- LuaFormatter off
					CONTINUE = { icon = "" ,color = "info"		,alt = { "CONTINUE" } },
					REMOVE   = { icon = " ",color = "warning"	,alt = { "REMOVE" } }
					-- LuaFormatter on
				},
				merge_keywords = true
			})
			require("telescope").load_extension("todo-comments")
		end
	})

	--
	use({
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
				require("telescope").load_extension("ui-select")
		end
	})

	-- Github cli; very limited
	-- use({
	-- 	disable = true,
	-- 	"nvim-telescope/telescope-github.nvim",
	-- 	config = function()
	-- 		require("telescope").load_extension("gh")
	-- 		require("legendary").keymaps({
	-- 			{ mode = { "n" } ,description = "Repo: githubcli (Telescope)" ,"<C-B>" ,"<CMD>Telescope gh<CR>"}
	-- 		})
	-- 	end
	-- })

end

M.init = function(self, legendary)

	self.legendary = {}
	-- LuaFormatter off
	self.legendary.keymaps = {
			  { mode = { "n" } ,description = "Window: palettes: keymaps & commands (Telescope)"	,"<CMD>Telescope<CR>"}
			, { mode = { "n" } ,description = "Window: commands (Telescope)"						,"<CMD>Telescope commands<CR>"}
			, { mode = { "n" } ,description = "Buffer: go to buffer (Telescope)"					,"<CMD>Telescope buffers<CR>"}
			, { mode = { "n" } ,description = "Buffer: switch (Telescope)"							,"<C-B>" ,"<CMD>Telescope buffers<CR>"}

			, { mode = { "n" }, description = "Tabs: go to tab (Telescope)"											,					 "<CMD>Telescope telescope-tabs list_tabs<CR>"	}
			, { mode = { "n" }, description = "Tabs: switch (Telescope extension)"									, "<C-P>"			,"<CMD>Telescope telescope-tabs list_tabs<CR>"	}
			, { mode = { "n" }, description = "Window: settings: edit global editor options (Telescope)"			,					 "<CMD>Telescope vim_options<CR>"				}
			, { mode = { "n" }, description = "Window: settings: colorscheme: switch (Telescope)"					,					 "<CMD>Telescope colorscheme<CR>"				}
			, { mode = { "n" }, description = "Workspace: search for string across files (Telescope live_grep)" 	,					 "<CMD>Telescope live_grep<CR>"					}
			, { mode = { "n" }, description = "Workspace: search for string across files (Telescope live_grep)" 	, "<C-O><C-F>", function()
				require("telescope.builtin").live_grep({
					-- hidden=true,
				    glob_pattern="*.*",
					max_results=2048
				})
				end
			  }
			, { mode = { "n" }, description = "Workspace: telescope: list todos"			  ,					 ":TodoTelescope<CR>"						}
			, {
				itemgroup = "File",
				keymaps = {
					 {	mode = { "n" }, "<C-O><C-R>" ,description = "File: find/open recent files (Telescope)",
						function()
							require("telescope").extensions.recent_files.pick({
									-- Finds already opened window and focus it
								attach_mappings = telescopeTabDrop,
								hidden = true
							})
						end
					  }
					-- , { mode = { "n" }, description = "File: telescope: find/open files" , "<C-O><C-O>"	,":Telescope find_files<CR>" }
					, { mode = { "n" }, description = "File: telescope: find/open files" , "<C-O><C-O>"	, function()
						require("telescope.builtin").find_files({
							  hidden = true
							, no_ignore=false
						})
					end }
					, { mode = { "n" }, description = "File: telescope: change language mode/file type" ,					 ":Telescope filetypes<CR>" }
					-- Remove?
					-- , { mode = { "n" }, description = "File: telescope: change file type",  "<C-K>m",
					-- 	function()
					-- 		vim.notify("[Legendary]: This is not VS Code. Language mode is not part of nvim, search Legendary \"change file type\" instead", vim.log.levels.WARN)
					-- 	end
					--   }
				}
			}
	}
	-- LuaFormatter on

	self.legendary.funcs = {
		{
			-- mode = { "n" },
			description = "Workspace: telescope: list todos in cwd",
			function()
				require("telescope").extensions["todo-comments"].todo({
					cwd = vim.fn.expand("%:h"),
					attach_mappings = telescopeTabDrop,
				})
			end
		},
		{
			itemgroup = "File",
			funcs = {
				  { description = "File: telescope: fuzzy search", function() vim.cmd(":Telescope") end }
			}
		}
	}

	self.legendary.autocmds = {
		-- This handler sets Telescope border to a bright one when colorscheme
		-- is changed; usually in dark mode
		{
			"ColorScheme",
			description = "Window: make telescope float window border bright",
			opts = {},
			function(opts)
				local isCatppuccinDarkTheme = not vim.g.colors_name	== "catappuccin-latte"
				local isMaterialDarkTheme = vim.g.colors_name ~= "material"
					and vim.g.material_style ~= "lighter"

				local isDarkTheme = isCatppuccinDarkTheme or isMaterialDarkTheme
				if isDarkTheme then
					-- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#ff8800" })
					-- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#aaaaaa" })
					vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#4a5365" })
				end
			end
		}
	}

	legendary.keymaps(self.legendary.keymaps)
	legendary.autocmds(self.legendary.autocmds)
	legendary.funcs(self.legendary.funcs)

end

return M
