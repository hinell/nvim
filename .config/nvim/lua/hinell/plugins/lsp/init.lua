-- @module hinel-config-lsp
-- Configuration for programming languages support and LSP servers
-- local string = require("string")
local M           = {}

M.legendary = {}
M.legendary.init = function(self, legendary, telescope)

	self.legendary = {}
	self.legendary.keymaps = {
		{ mode = "n" ,description = "File: LSP: switch header/implementation", ":ClangdSwitchSourceHeader<CR>" }
	}

	-- LuaFormatter off
	self.legendary.functions = {
		{
			description = "Buffer: lsp: hover",
			function()
				if #vim.lsp.get_clients() > 0 then
					vim.lsp.buf.hover()
				end
			end
		}
		, {
			itemgroup = "File",
			funcs = {
				{
					description = "File: lsp: format",
					function()
						if #vim.lsp.get_clients() > 0 then
							vim.lsp.buf.format({
								filter = function(client)
									-- Prefer emf-language-server
									if client.name == "efm" then
										return true
									end
									return true
								end
							})
						end
					end
				}
			}
		}
		, {
			description = "Buffer: lsp: symbol rename",
			function()
				if #vim.lsp.get_clients() > 0 then
					vim.lsp.buf.rename()
				end
			end
		}
	}
	-- LuaFormatter on

	-- The following code dynamically provides all telescope.lsp_ builtins
	-- to the Legendary to be listed
	if legendary and telescope then
		telescope.builtin = require("telescope.builtin")

		local legendaryKeymaps = {}
		local legendaryFuncs   = {}

		for k,v in pairs(telescope.builtin) do
			-- LuaFormatter off
			if k:match("lsp_") then
				local description = ("Buffer: LSP: %s (Telescope)"):format(k:gsub("lsp_", ""))
					  description = description:gsub("_", " ")
				local entry = {
					  mode = "n"
					, description = description
					, nil
				}
				local iskeymap = false
				if k:match("lsp_document_symbols")  then iskeymap = true table.insert(entry, "<C-S-O>") end -- CTRL+SHIFT+O
				if k:match("lsp_workspace_symbols") then iskeymap = true table.insert(entry, "<C-S-W>") end -- CTRL+SHIFT+W

				table.insert(entry, function()
					-- Setup picker default action to open existing tab
					telescope.builtin[k]({
						attach_mappings = function(_, map)
							map({ "i", "n" }, "<CR>", require("telescope.actions").select_tab_drop)
							return true
						end
					})
				end)
				-- If we have a keys bound above, then push into a keymaps
				-- otherwise to functions
				if iskeymap then
					table.insert(legendaryKeymaps, entry)
				else
					table.insert(legendaryFuncs, entry)
				end

			end
			-- LuaFormatter on
		end
		legendary.keymaps(legendaryKeymaps)
		legendary.funcs(legendaryFuncs)
	end

	self.legendary.autocmds = {
		{
			"LspAttach",
			description = "Bind legendary keymaps if LSP server is available",
			function()
				legendary.keymaps(self.legendary.keymaps)
				return true
			end,

			opts = {
				-- once = true
			}
		},
		-- {
		-- 	"BufWritePre",
		-- 	description = 'Format on save',
		-- 	function()
		-- 		if #vim.lsp.get_active_clients() > 0 then
		-- 			vim.lsp.buf.format()
		-- 		end
		-- 	end
		-- }
	}

	-- Setup Legendary
	-- NOTE: DO NOT BIND keymaps here, as these are funcs
	legendary.funcs(self.legendary.functions)
	legendary.autocmds(self.legendary.autocmds)

end

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use

	use({
		"luals/lua-language-server"
		,
		run = {
			"git pull --recurse-submodules --depth 1"
			, "./make.sh"
		}
		,
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				-- TODO: [May 12, 2023] Install lua_ls via Packer & build it! May be setup.sh?
				cmd = { "/home/" .. os.getenv("USER") .. "/.local/share/nvim/site/pack/packer/start/lua-language-server/bin/lua-language-server" },
				runtime = {
					version = "LuaJIT"
				}
			})
		end
	})

	use({
		"neovim/nvim-lspconfig"
		,
		requires = {
			-- NOT A LUA MODULE
			-- "hrsh7th/vscode-langservers-extracted",
			"luals/lua-language-server"
		}
		,
		config = function()
			--Enable (broadcasting) snippet capability for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
				  capabilities.textDocument.completion.completionItem.snippetSupport = true

			local lspconfig = require("lspconfig")
			lspconfig.clangd.setup({})
			lspconfig.efm.setup(require("hinell.plugins.lsp.servers.efm").config)
			lspconfig.tsserver.setup({})
			-- lspconfig.jsonls.setup(require("hinell.plugins.lsp.servers.jsonls"))
			lspconfig.yamlls.setup(require("hinell.plugins.lsp.servers.yamlls"))
			lspconfig.bashls.setup({
				-- NOTE: Update this when zsh tree-sitter grammar is available
				-- TODO: [September 28, 2023] Disable formatter, use efm one
				filetypes={ "sh", "bash", "zsh" }
			})
			-- lspconfig.eslint.setup({})
			lspconfig.html.setup({})
			lspconfig.cssls.setup({})
			lspconfig.sqlls.setup({})
			lspconfig.vimls.setup({})
		end
	})

	-- Utility for LSP server request injection
	-- ARCHIVED on Aug 12, 2023
	-- use({ "jose-elias-alvarez/null-ls.nvim" })

	-- Generatoe .gitignore
	-- TODO: [May 12, 2023] Install & Setup Symbol overview
	-- Replaced by https://github.com/stevearc/aerial.nvim ?
	use({ "simrat39/symbols-outline.nvim" })

	use({
		"hinell/lsp-timeout.nvim",
		setup = function()
			vim.g["lsp-timeout-config"] = {
				-- stopTimeout  = 1000,
				-- startTimeout = 1000,      -- ms before restart
				-- silent       = true,          -- true to suppress notifications
				-- autoEdit     = true           -- true to automatically run :edit
			}
		end,
		requires={ "neovim/nvim-lspconfig" }
	})

	use({
		"creativenull/efmls-configs-nvim",
		tag = 'v1.*',
		requires = { 'neovim/nvim-lspconfig' }
	})

end

return M
