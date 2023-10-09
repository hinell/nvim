--- @module bigfile
-- Various tweaks for big file editing; disabling different features
local augroup = vim.api.nvim_create_augroup
local auclear = vim.api.nvim_clear_autocmds
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

local M = {}
M.init = function(self, pm)
	local use = pm.use
	-- Disables unneeded features so it's easier to edit big files
	-- Various tweaks for big file editing; disabling different features
	use({
		enabled = true,
		"LunarVim/bigfile.nvim",
		config = function(opts)
			vim.g.loaded_bigfile_plugin = not opts.enabled
			require("bigfile").setup({
				features = {
					"indent_blankline",
					"illuminate",
					-- "lsp",
					"treesitter",
					"syntax",
					"matchparen",
					"vimopts",
					"filetype",
				},
			})
		end
	})

	local auBigFileGroupName = "BigFileOptimizer"
	augroup(auBigFileGroupName, {})
	autocmd({
			"BufReadPost"
	},{
		pattern = {
			"*.md",
			"*.rs",
			"*.lua",
			"*.sh",  "*.bash", "*.zsh",
			"*.js" , "*.jsx", "*.ts", "*.tsx",
			"*.c"  , ".h"   ,
			"*.cc" , ".hh"  ,
			"*.cpp", ".cph" ,
			-- "*.txt"
		},
		group = auBigFileGroupName,
		callback = function(auEvent)

			local bufnr = auEvent.buf
			local auPathMatched = auEvent.match;
			local bufferCurrentLinesCount = vim.api.nvim_buf_line_count(0)

			-- cover big help files
			if string.match(auPathMatched, ".txt") and vim.bo[bufnr].buftype ~= "help" then
				return
			end

			local iblOk, ibl = pcall(require, "ibl")
			if bufferCurrentLinesCount > 768 then
				-- Left-column indent higlights
				-- vim.notify("hinell-config: bigfile: indent highlights are reconfigured to increase performance!", vim.log.levels.WARN)
				-- local iblBufSetupOk = pcall(ibl.setup_buffer,auEvent.buf, {
				-- 	debounce = 1278,
				-- })
			end

			-- local ft = vim.api.nvim_get_option_value("ft", { buf = auEvent.buf })
			-- vim.bo.filetype
			if bufferCurrentLinesCount > 2048 then
				vim.notify("hinell-config: bigfile: swapfiles are disabled!", vim.log.levels.WARN)
				vim.bo.swapfile = false
				-- Higlight colors numbers e.g. #ffffff
				vim.notify("hinell-config: bigfile: colorizer is disabled!", vim.log.levels.WARN)
				pcall(vim.cmd, "ColorizerDetachFromBuffer")
				-- pcall(vim.cmd, "ColorizerToggle")

				-- print(("%s: hinell-bigfile optimized is disabled"):format(debug.getinfo(1).source))
				-- if true then return end
				vim.notify("hinell-config: bigfile: the file is big, some features will be disabled!", vim.log.levels.WARN)

				-- nvim-sitter folding
				vim.notify("hinell-config: bigfile: nvim-treesitter folding is disabled!", vim.log.levels.WARN)
				vim.cmd("TSBufDisable indent")
				vim.wo.foldmethod = "indent"
				vim.wo.foldexpr   = nil

				-- tree-sitter-context
				vim.notify("hinell-config: bigfile: nvim-treesitter-context is disabled!", vim.log.levels.WARN)
				pcall(vim.cmd, "TSContextDisable") --[[@diagnostic disable]]

				-- tree-sitter-hihglights
				vim.notify("hinell-config: bigfile: nvim-treesitter-highlights are disabled!", vim.log.levels.WARN)
				pcall(vim.cmd, "TSBufToggle highlight") --[[@diagnostic disable]]

				-- hlchunk
				vim.notify("hinell-config: bigfile: hlchunk,indent,linums are disabled!", vim.log.levels.WARN)
				pcall(vim.cmd, "DisableHL") --[[@diagnostic disable]]
				pcall(vim.cmd, "DisableHLChunk") --[[@diagnostic disable]]
				pcall(vim.cmd, "DisableHLIndent") --[[@diagnostic disable]]
				pcall(vim.cmd, "DisableHLLineNum") --[[@diagnostic disable]]

				-- vim-matchup is very inefficient
				vim.notify("hinell-config: bigfile: nvim-treesitter-vim-matchup is disabled!", vim.log.levels.WARN)
				vim.g.matchup_matchparen_enabled = 0
				require("nvim-treesitter.configs").setup({
					matchup = {
						enable = false
					}
				})

				-- Left-column indent higlights
				-- vim.notify("hinell-config: bigfile: indent highlights are disabled entirely!", vim.log.levels.WARN)
				-- pcall(vim.cmd, "IBLDisable")

			end
		end
	})

end
return M

