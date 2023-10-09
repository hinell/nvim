-- @module M
-- M
-- Statuscolumn plugins
local M = {}

M.init = function(self, pm)

	local use = pm.use
	use({
		"luukvbaal/statuscol.nvim",
		config = M.config
	})

end

M.config = function()

	local builtin = require("statuscol.builtin")

	local legendaryIsOk, legendary = pcall(require, "legendary")
	if not legendaryIsOk then
		return
	end

	require("statuscol").setup({
		setopt = true,
		-- order = "SFNs", -- Deprecated

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

	local autocmds = {
		-- This toggles relative column numbers depending on a mode
		{
			description = "Autocommands for mode switching",
			-- { "WinEnter", "InsertEnter" },
			{ "ModeChanged" },
			opts = { pattern = "[nvV]:*" },
			function()
				local napi		= require("nvim-api")
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
			description = "Autocommands for mode switching",
			-- { "InsertLeave" },
			{ "ModeChanged" },
			opts = { pattern = "*:[nvV]" },
			function()
				local hasNapi, napi	= pcall(require, "nvim-api")
				-- This prevents Telescope input line to get number columns
				if napi.buffers.types.special:contains(vim.bo.buftype) then
					return
				end
				vim.wo.relativenumber = true
			end
		}

	}
	legendary.autocmds(autocmds)

end

return M


