return function()
	require("catppuccin").setup({
		-- transparent_background = true,
		-- no_italic = true,
		-- no_bold   = true,
		dim_inactive = {
			-- dims the background color of inactive window
			enabled = false,
			shade = "dark",
			-- percentage of the shade to apply to the inactive window
			percentage = 0.30,
		},
		-- TODO: [October 03, 2023] Catpuccin theme: Update integrations
		integrations = {
			cmp        = true,
			gitsigns   = true,
			nvimtree   = true,
			treesitter = true,
			notify     = false,
			mini       = true,
			markdown   = true,
			treesitter_context = false,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = false
			},
		}
	})
end
