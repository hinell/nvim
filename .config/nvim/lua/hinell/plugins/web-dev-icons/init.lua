--- @module web-dev-icons
--- Nvim Devicons configuration for packer
local M = {}

M.config = function()
	require("nvim-web-devicons").setup({

		-- globally enable different highlight colors per icon (default to true)
		-- if set to false all icons will have the default icon"s color
		color_icons = false,

		-- globally enable default icons (default to false)
		-- will get overriden by `get_icons` option
		default = true,
		config = function()
			-- set termguicolors to enable highlight groups
			vim.opt.termguicolors = true
		end,

		-- your personnal icons can go here (to override)
		-- you can specify color or cterm_color instead of specifying both of them
		-- DevIcon will be appended to `name`
		override = {
			zsh = {
				icon = "",
				color = "#428850",
				cterm_color = "65",
				name = "Zsh",
			},
			html = {
				icon = "",
				color = "#DE8C92",
				name = "html",
			},
			css = {
				icon = "",
				color = "#61afef",
				name = "css",
			},
			js = {
				icon = "",
				color = "#EBCB8B",
				name = "js",
			},
			ts = {
				icon = "ﯤ",
				color = "#519ABA",
				name = "ts",
			},
			rs = {
				icon = "",
				color = "#FFAA30",
				name = "rs",
			},
			kt = {
				icon = "󱈙",
				color = "#ffcb91",
				name = "kt",
			},
			png = {
				icon = "",
				color = "#BD77DC",
				name = "png",
			},
			jpg = {
				icon = "",
				color = "#BD77DC",
				name = "jpg",
			},
			jpeg = {
				icon = "",
				color = "#BD77DC",
				name = "jpeg",
			},
			mp3 = {
				icon = "󰎆",
				color = "#C8CCD4",
				name = "mp3",
			},
			mp4 = {
				icon = "",
				color = "#C8CCD4",
				name = "mp4",
			},
			out = {
				icon = "",
				color = "#C8CCD4",
				name = "out",
			},
			toml = {
				icon = "",
				color = "#61afef",
				name = "toml",
			},
			lock = {
				icon = "",
				color = "#DE6B74",
				name = "lock",
			},
			zip = {
				icon = "",
				color = "#EBCB8B",
				name = "zip",
			},
			xz = {
				icon = "󰿺",
				color = "#EBCB8B",
				name = "xz",
			},
			["in"] = {
				icon = "",
				color = "#DDDDFF",
				name = "infile",
			},
		},
	})
end

M.init = function(self, packer)
	local use = packer.use
	use({ "nvim-tree/nvim-web-devicons", config = self.config })
end

return M
