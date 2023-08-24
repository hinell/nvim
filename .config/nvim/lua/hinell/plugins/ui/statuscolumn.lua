-- @module M
-- M
-- Statuscolumn plugins
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use

	use({
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				setopt = true,
				-- order = "SFNs", -- Deprecated
				--
				ft_ignore = { "NvimTree", "help", "man", "qf", "DiffViewFiles" },
				segments = {
				  { text = { "%s" }, click = "v:lua.ScSa" },
				  {
				    text = { builtin.lnumfunc, " " },
				    condition = { true, builtin.not_empty },
				    click = "v:lua.ScLa",
				  },
				  { text = { "%C" }, click = "v:lua.ScFa" }
				}
			})
		end
	})

end


M.legendary = {}
M.legendary.autocmds = {

	-- This is a telescope util?
	{
		name = "Modetoggle",
		description = "Autocommands for mode switching",
		{
			-- { "WinEnter", "InsertEnter" },
			{ "ModeChanged" },
			opts = { pattern = "[nvV]:*" },
			function()
				local napi		= require("hinell.nvim-api")
				if napi.buffers.types.special:contains(vim.bo.buftype) then
					return
				end
				-- This prevents Telescope input line to get number columns
				if not vim.o.readonly then
					vim.wo.relativenumber = false
				end
			end
		},

		{
			-- { "InsertLeave" },
			{ "ModeChanged" },
			opts = { pattern = "*:[nvV]" },
			function()
				local napi		= require("hinell.nvim-api")
				-- This prevents Telescope input line to get number columns
				if napi.buffers.types.special:contains(vim.bo.buftype) then
					return
				end
				vim.wo.relativenumber = true

			end
		}
	}
}
M.legendary.init = function(self, legendary)
	legendary.autocmds(self.autocmds)
end
return M


