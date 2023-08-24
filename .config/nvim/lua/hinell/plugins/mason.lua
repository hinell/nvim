-- @module hinell-config-mason
-- Mason plugin config for Hinell
local M = {}

M.init = function(self, packer)
	local use = packer.use
	-- code
	use({ "williamboman/mason.nvim", config = function() require("mason").setup() end })
	use({ "williamboman/mason-lspconfig.nvim", config = function ()
		ensure_installed = {
			-- Uncomment only if you don't want to use system wide installation 
			-- "lua_ls",
			-- "clangd",
			-- "bashls",
			-- "jsonls"
		}
	end })
end

return M
