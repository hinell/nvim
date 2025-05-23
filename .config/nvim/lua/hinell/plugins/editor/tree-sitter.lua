--- @module nvim-treesitter
-- nvim-treesitter config
local M = {}
M.init = function(self, pm)
	local use = pm.use

	use({
		"nvim-treesitter/nvim-treesitter",
		enabled = true,
		build = ":TSUpdate",
		-- NOTE: [October 17, 2023] main version doesn't have config folder!
		version = "master",
		init = function()
			-- PERF: [October 20, 2023] This slows down nvim! heavily, use :profile  for debugging
			-- vim.opt.foldmethod = "indent"
			-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			-- vim.opt.foldenable = false

		end,
		config = M.config
	})

end

M.config = function ()
	require("nvim-treesitter.configs").setup({
		-- A list of parser names, or "all"
		-- LuaFormatter off
		ensure_installed = {
			"c", "cpp", "make", "cmake", "meson",
			"bash", "perl",
			"regex",
			"lua", "vim",
			"typescript", "tsx",
			"javascript", "html", "css", "scss", "jsdoc",
			"markdown", "markdown_inline",
			"diff",
			"git_config", "gitattributes", "gitcommit", "gitignore", "git_rebase",
			"json", "json5", "jsonc", "yaml", "toml", "jq",
			"ebnf",
			"sql",
			"query",
			"dot", "doxygen",
			"xml"
		},
		-- LuaFormatter on
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		auto_install = true,

		-- List of parsers to ignore installing (for "all")
		-- ignore_install = {  },

		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			disable = {},
			-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
			disable = function(lang, buf)
				local max_filesize = 1024 * 1024 -- 1MB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,

		},
		-- LuaFormatter off
		incremental_selection = {
			enable = false,
			keymaps = {
				-- init_selection    = "gnn", -- set to `false` to disable
				-- node_incremental  = "gnrn",
				-- node_decremental  = "gnrm",
				-- scope_incremental = "gnrc"
			},
		}
		-- LuaFormatter on
	})

	local legendaryIsOk, legendary = pcall(require, "legendary")
	if legendaryIsOk then

		-- local keymaps = {
		-- 	{}
		-- }
		-- legendary.keymaps(keymaps)
	end

end

return M

