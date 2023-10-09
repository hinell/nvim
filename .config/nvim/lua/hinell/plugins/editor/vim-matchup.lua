--- @module vim-matchup
-- M
-- Plugin for % hotkey
local M = {}

M.init = function(self, packer)
	-- PERF: [October 20, 2023] This slows down nvim! heavily, use :profile  for debugging
	local use = packer.use
	vim.g.loaded_matchparen = 1

	use({
		"andymass/vim-matchup",
		enabled = false,
		config = function(opts)

			vim.g.matchup_matchparen_offscreen              = { method = "popup" }
			vim.g.matchup_matchparen_singleton              = 0
			vim.g.matchup_matchparen_deferred               = 0
			vim.g.matchup_matchparen_deferred_show_delay    = 1000 * 10
			vim.g.matchup_matchparen_deferred_hide_delay    = 1000 * 15
			vim.g.matchup_matchparen_deferred_fade_time     = 0
			vim.g.matchup_delim_stopline                    = 1024
			vim.g.matchup_matchparen_stopline               = 512
			vim.g.matchup_matchparen_pumvisible             = 1
			vim.g.matchup_matchparen_nomode                 = { "i" }
			vim.g.matchup_matchparen_hi_surround_always     = 0
			vim.g.matchup_matchparen_hi_background          = 0
			-- vim.g.matchup_matchparen_start_sign             = "❭"
			-- vim.g.matchup_matchparen_end_sign               = "❬"
			vim.g.matchparen_timeout                        = 1000 * 1
			vim.g.matchparen_insert_timeout                 = 60
			vim.g.matchup_delim_count_fail                  = 0
			vim.g.matchup_delim_count_max                   = 8
			vim.g.matchup_delim_start_plaintext             = 1
			vim.g.matchup_delim_noskips                     = 0
			vim.g.matchup_delim_nomids                      = 0
			vim.g.matchup_motion_enabled                    = 1
			vim.g.matchup_motion_cursor_end                 = 1
			vim.g.matchup_motion_override_Npercent          = 0
			vim.g.matchup_motion_keepjumps                  = 0
			vim.g.matchup_text_obj_enabled                  = 1
			vim.g.matchup_text_obj_linewise_operators       = { "y" }
			vim.g.matchup_transmute_enabled                 = 0
			vim.g.matchup_transmute_breakundo               = 0
			vim.g.matchup_mouse_enabled                     = 1
			vim.g.matchup_surround_enabled                  = 0
			vim.g.matchup_where_enabled                     = 1
			vim.g.matchup_where_separator                   = ""
			vim.g.matchup_matchpref                         = {}


			require("nvim-treesitter.configs").setup({
				matchup = {
					enabled = true,              -- mandatory, false will disable the whole extension
					-- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
				}
			})

			-- disable builtin matchit plugin
			vim.g.loaded_matchit = 1
		end
	})
end

return M
