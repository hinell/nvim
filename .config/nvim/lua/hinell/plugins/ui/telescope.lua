-- @module hinell-pluins-telescope

-- This function is intended for to be used for Telescope pickers
--- @usage  telescope.ext.pick({  attach_mappings = telescopeTabDrop })
local telescopeTabDrop = function(_, map)
	  map({ "i", "n" }, "<CR>", require("telescope.actions").select_tab_drop)
	  return true
	end

local M = {}

M.packer = {}

M.config = function(pm)

	local actions = require("telescope.actions")
	local state   = require("telescope.actions.state")
	local builtin = require("telescope.builtin")

	-- state.
	local inserPathPluginIsOk, inserPathPlugin = assert(pcall(require, "telescope_insert_path"))

	local config  = {
		-- uniq_string
		defaults = {
			border   = true,
			mappings = {
				n = {
					["p."] = inserPathPluginIsOk and inserPathPlugin.insert_relgit_a_visual or nil,
					["p="] = inserPathPluginIsOk and inserPathPlugin.insert_abspath_a_visual or nil,
					-- ["y"] = {
					-- 	type = "action",
					-- 	function(...)
					-- 		local entry = state.get_selected_entry()
					--
					-- 		print(("%s: yank?"):format(debug.getinfo(1).source))
					-- 		print(vim.inspect(...))
					-- 	end
					-- }

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
					["<CR>"] = actions.select_tab_drop,
				},
				n = {
					["<CR>"] = actions.select_tab_drop,
					["<Del>"] = function(arg)
						-- TODO: [Friday, January 13, 2023] Map <del> for unlisted buffers removal

						local action_state = require "telescope.actions.state"
						local selected = action_state.get_selected_entry()

						if selected and selected.bufnr  then
							-- vim.cmd("bdelete " .. selected.bufnr)
							vim.cmd("wq!")
						end
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
		,	diagnostics	= { mappings = { i = { ["<CR>"] = actions.select_tab_drop } } }
		-- LuaFormatter on
	}
	-- Set up pickers for all lsp_* builtins
	-- NOTE: we don't need to do this for every builtin, as some may misbehave
	for k,v in pairs(builtin) do
		if vim.startswith(k, "lsp_") then
			local pickerCfg     = config.pickers[k]
		    pickerCfg			= pickerCfg or {}
			pickerCfg.mappings  = { i = { ["<CR>"] = actions.select_tab_drop } }
			pickerCfg.jump_type = "never"
			config.pickers[k]   = pickerCfg
		end
	end

	local telescope = require("telescope")
	telescope.setup(config)

	local legendaryIsOk, legendary = pcall(require, "legendary")
	if not legendaryIsOk then
		error(("%s: legendary is not ok"):format(debug.getinfo(1).source))
		return
	end
	-- LuaFormatter off
	local keymaps = {
			  { mode = { "n" } ,description = "Window: palettes: keymaps & commands (Telescope)"	,"<CMD>Telescope<CR>"}
			, { mode = { "n" } ,description = "Window: palettes: resume (Telescope)"	,"<CMD>Telescope<CR>"}
			, { mode = { "n" } ,description = "Window: commands (Telescope)"	,"<CMD>Telescope commands<CR>"}
			, { mode = { "n" } ,description = "Editor: go to buffer (Telescope)","<CMD>Telescope buffers<CR>"}
			, { mode = { "n" } ,description = "Editor: switch (Telescope)"		,"<C-P><C-B>" ,"<CMD>Telescope buffers<CR>"}
			, { mode = { "n" }, description = "Tabs: go to tab (Telescope)" ,"<CMD>Telescope telescope-tabs list_tabs<CR>" }
			, { mode = { "n" }, description = "Tabs: switch (Telescope)", "<C-P>"			,"<CMD>Telescope telescope-tabs list_tabs<CR>" }

			, { mode = { "n" }, description = "Window: settings: edit global editor options (Telescope)"			,					 "<CMD>Telescope vim_options<CR>" }
			, { mode = { "n" }, description = "Window: settings: colorscheme: switch (Telescope)",					 "<CMD>Telescope colorscheme<CR>" }
			, { mode = { "n" }, description = "Editor: navigate across Tree-Sitter symbols (Telescope treesitter)"	,"<C-S-O>ts", "<CMD>Telescope treesitter<CR>" }
			, { mode = { "n" }, description = "Editor: search string (Telescope)" 			,					 "<CMD>Telescope current_buffer_fuzzy_find <CR>" }
			, { mode = { "n" }, description = "Workspace: search string in files (Telescope live_grep)" 			,					 "<CMD>Telescope live_grep<CR>" }
			, { mode = { "n" }, description = "Workspace: search string in files (Telescope grep_string)" 			, 					 "<CMD>Telescope grep_string<CR>" }
			, { mode = { "n" }, description = "Workspace: search string in git files (Telescope grep_string)" 		, "<C-O><C-F>g",		 "<CMD>Telescope git_files<CR>"	}
			, { mode = { "n" }, description = "Workspace: search string in workspace files (Telescope live_grep)" 	, "<C-O><C-F>", function()
				require("telescope.builtin").live_grep({
					-- hidden=true,
				    glob_pattern="*",
					max_results=1024
				})
				end
			  }
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
					-- , { mode = { "n" }, description = "File: tls: find/open files" , "<C-O><C-O>"	,":Telescope find_files<CR>" }
					, { mode = { "n" }, description = "File: tls: find/open files" , "<C-O><C-O>"	, function()
						require("telescope.builtin").find_files({
							  hidden = true
							, no_ignore=false
						})
					end }
					, { mode = { "n" }, description = "File: tls: change language mode/file type" ,					 ":Telescope filetypes<CR>" }
					-- Remove?
					-- , { mode = { "n" }, description = "File: tls: change file type",  "<C-K>m",
					-- 	function()
					-- 		vim.notify("[Legendary]: This is not VS Code. Language mode is not part of nvim, search Legendary \"change file type\" instead", vim.log.levels.WARN)
					-- 	end
					--   }
				}
			}

	}
	-- LuaFormatter on

local funcs = {
		{
			itemgroup = "File",
			funcs = {
				  { description = "File: tls: fuzzy search", function() vim.cmd(":Telescope") end },
			}
		},
		{
			itemgroup = "Help",
			description = "Help commands",
			funcs = {
				{ description = "tls: help tags", require("telescope.builtin").help_tags },
				{ description = "tls: man pages", require("telescope.builtin").man_pages },
			}

		},
		{ description = "Editor: tls: open quickfix list", require("telescope.builtin").quickfix },
		{ description = "Editor: tls: open locations list", require("telescope.builtin").loclist }
	}

	local gitFuncs = {}
	-- Setup commands & keymaps Legendary for git pickers
	telescope.builtin = require("telescope.builtin")
	for k,v in pairs(telescope.builtin) do
		-- LuaFormatter off
		if k:match("git_") then
			local description = ("Editor: git: %s (Telescope)"):format(k:gsub("git_", ""))
				  description = description:gsub("_", " ")
			local iskeymap = false

			if iskeymap then
				--
				-- local entry = {
				-- 	  mode = "n"
				-- 	, description = description
				-- 	, nil
				-- }
				-- table.insert(keymaps, entry)
			else
				local entry = {
					 description = description
					, telescope.builtin[k]
				}

				table.insert(gitFuncs, entry)
			end

		end
		-- LuaFormatter on
	end

	table.insert(funcs, {
		itemgroup   = "Git",
		funcs       = gitFuncs,
		description = "Git commands",
	})

	local autocmds = {
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

	legendary.keymaps(keymaps)
	legendary.autocmds(autocmds)
	legendary.funcs(funcs)

end

M.init = function(self, packer)
	local use = packer.use
	use({
		-- This config should come before extensions
		"nvim-telescope/telescope.nvim"
		, dependencies = {
				"nvim-lua/plenary.nvim"
		}
		,	config = M.config
	})

	-- Plugin that allows pasting focused file path
	use({
		"kiyoon/telescope-insert-path.nvim",
		description = "Insert a file path of the selected Telescope entry into the current",
		dependencies = { "nvim-telescope/telescope.nvim" },
		-- this plugin is configured by using telescope.config.defaults.mapping
	})

	use({
		"nvim-telescope/telescope-fzf-native.nvim"
		, build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
		, dependencies = {
			"nvim-telescope/telescope.nvim"
		}
		-- , build = "make"
		, config = function()
			require("telescope").load_extension("fzf")
		end
	})

	use({
		"smartpde/telescope-recent-files"
		, dependencies = {
			"nvim-telescope/telescope.nvim"
		}
		, config = function() require("telescope").load_extension("recent_files") end
	})

	use({
		"olacin/telescope-cc.nvim"
		, dependencies = {
			"nvim-telescope/telescope.nvim"
		}
		, config = function()
			local telescope = require("telescope")
			telescope.load_extension("conventional_commits")
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then

				legendary.keymap({
					itemgroup = "Git",
					keymaps = {
						{
							mode = { "n" },
							description = "Workspace: git: commit staged changes (cc)",
							"<CMD>Telescope conventional_commits<CR>"
						}
					}
				})

				legendary.func({
					itemgroup = "Git",
					funcs = {
						{
							mode = { "n" },
							description = "Editor: git: stage and commit (cc)",
							function()
							local gitsigns = require("gitsigns")
								gitsigns.stage_buffer()
								telescope.extensions.conventional_commits.conventional_commits()
							end
						},
						{
							mode = { "n" },
							description = "Editor: git: hunk: stage and commit (cc)",
							function()
								local gitsigns = require("gitsigns")
								gitsigns.stage_hunk()
								telescope.extensions.conventional_commits.conventional_commits()
							end
						}
					}
				})
			end
		end
	})


	use({
		"nvim-telescope/telescope-ui-select.nvim",
		enabled = false,
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

	use({
		"radyz/telescope-gitsigns",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			require("telescope").load_extension("git_signs")

			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				-- LuaFormatter off
				legendary.funcs({
					{
						itemgroup = "Git",
						funcs = {
							{ mode = { "n" }, description = "Editor: git: gitsigns: go to hunks", require("telescope").extensions.git_signs.git_signs }
						}
					}
				})
			end
		end
	})
end

return M
