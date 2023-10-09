---@diagnostic disable: redefined-local
-- Configuration for programming languages support and LSP servers
-- local string = require("string")
local M           = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local auclear = vim.api.nvim_clear_autocmds

local uv = vim.uv or vim.loop

M.legendary = {}
M.legendary.init = function(self, opts)

	local opts = { buffer = opts.bufnr }
	self.legendary = {}
	self.legendary.keymaps = {
		{
			itemgroup   = "LSP",
			description = "LSP related functions",
			keymaps     = {
				-- -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#clangd
				-- -- https://github.com/p00f/clangd_extensions.nvim
				-- 	mode = "n"
				-- 	, description = "File: lsp: switch header/implementation"
				-- 	, ":ClangdSwitchSourceHeader<CR>"
				-- }
			}
		}
	}

	local lspFormatFunc = {
		description = "File: lsp: format",
		function()
			local clients = vim.lsp.get_clients()
			if #clients == 0 then
				vim.notify("[LSP]: no clients", vim.log.levels.INFO)
				return
			end
			local clientsNames = vim.tbl_map(function(c)
				local name = c.name
				return name
			end, clients)

			vim.ui.select(clientsNames, {
				prompt = "Specify LSP client"
			}, function(clientChosen)
				if not clientChosen then return false end
				vim.lsp.buf.format({
					filter = function(client)
						vim.notify("[LSP]: formatting: " .. clientChosen .. " server is used", vim.log.levels.INFO)
						return client.name == clientChosen
					end
				})
			end)
		end
	}
	-- LuaFormatter off
	self.legendary.functions = {
		{
			itemgroup   = "LSP",
			funcs = {
				lspFormatFunc,
				{
					description = "Editor: lsp: hover",
					function()
						if #vim.lsp.get_clients() > 0 then
							vim.lsp.buf.hover()
						end
					end
				},
				{ description = "Editor: lsp: symbol rename", vim.lsp.buf.rename },
				{ description = "Editor: lsp: signature help", function() vim.lsp.buf.signature_help() end },
				{ description = "Editor: lsp: type defintion", function() vim.lsp.buf.type_definition({ reuse_win = true }) end },
				{ description = "Editor: lsp: list subclasses", function() vim.lsp.buf.typehierarchy("subtypes") end },
				{ description = "Editor: lsp: list superclasses", function() vim.lsp.buf.typehierarchy("subtypes") end },
				{
					description = "Workspace: add folder", function ()
						vim.lsp.buf.add_workspace_folder()
					end
				},
				{
				   description = "Editor: lsp: code actions", function()
					   vim.cmd("startinsert")
					   vim.defer_fn(function()
						   vim.lsp.buf.code_action()
					   end, 100)
				   end, opts = opts
				}
			}
		},
		{
			itemgroup = "File",
			funcs = {
				lspFormatFunc
			}
		},

		{ mode = { "n" }, description = "Workspace: lsp: find references", vim.lsp.buf.references, opts = opts },
		{ mode = { "n" }, description = "Workspace: lsp: diagnostics (Telescope)", function() vim.cmd("Telescope diagnostics") end, opts = opts },
		{ mode = { "n" }, description = "Editor: lsp: diagnostics (Telescope)",function() vim.cmd("Telescope diagnostics bufnr=0") end, opts = opts }
	}
	-- LuaFormatter on

	local legendaryIsOk, legendary = pcall(require, "legendary")
	local telescopeIsOk, telescope = pcall(require, "telescope")
    -- Set up LSP pickers dynamically for all telescope.lsp_ builtins
	-- to the Legendary to be listed
	if legendaryIsOk and telescopeIsOk then
		-- Setup Legendary
		-- NOTE: DO NOT BIND keymaps here, as these are funcs
		legendary.keymaps(self.legendary.keymaps)
		legendary.funcs(self.legendary.functions)

		telescope.builtin = require("telescope.builtin")

		local legLspKeymaps = {
			-- { mode = { "i" }, description = "Editor: lsp: signagure help", "<M-C-K>" ,function() vim.lsp.buf.signature_help() end }
		}
		local legLspFuncs   = {}

		for k,v in pairs(telescope.builtin) do
			-- LuaFormatter off
			if k:match("lsp_") then
				local description = ("Editor: lsp: %s (Telescope)"):format(k:gsub("lsp_", ""))
					  description = description:gsub("_", " ")
				local entry = {
					  description = description
					, nil
					, opts = opts
				}
				local iskeymap = false
				if k:match("lsp_document_symbols")  then iskeymap = true table.insert(entry, "<C-S-O>") end -- CTRL+SHIFT+O
				if k:match("lsp_workspace_symbols") then iskeymap = true table.insert(entry, "<C-S-O>w") end -- CTRL+SHIFT+O+W

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
					entry.mode = "n"
					table.insert(legLspKeymaps, entry)
				else
					table.insert(legLspFuncs, entry)
				end

			end
			-- LuaFormatter on
		end

		legendary.keymaps({
			{
				itemgroup   = "LSP",
				keymaps     = legLspKeymaps
			}
		})

		-- local funcs = vim.list_extend(legLspFuncs, self.legendary.functions)
		legendary.funcs({
			{
				itemgroup   = "LSP",
				funcs       = legLspFuncs
			}
		})

	end
end

M.init = function(self, pm)
	local use = pm.use
    local lazyIsOk, lazy = pcall(require, "lazy")

	-- Set LSP loglevel
	vim.lsp.set_log_level(vim.log.levels.ERROR)

	local on_attach = function(client, bufnr)
		-- navic works only when documentSymbolProvider is enabled
		-- local _lspKeymapsAreSet = vim.g._lspKeymapsAreSet
		-- if not _lspKeymapsAreSet then
		-- 	vim.g._lspKeymapsAreSet = true
		-- end

		-- Silence navic plugin in case it tries to attach to two
		-- LSP in the same buffer
		vim.g.navic_silence = true
		require("nvim-navic").attach(client, bufnr)

	end

	-- TODO: [November 22, 2023] Install globally, not locally
	use({
		"luals/lua-language-server" ,
		run = {
			-- "git pull --recurse-submodules --depth 1",
			-- "./make.sh"
			"./3rd/luamake/luamake build bootstrap lua-language-server",
			"./3rd/luamake/luamake build copy_bootstrap copy_lua-language-server"
		}
	})

	use({
		"neovim/nvim-lspconfig",
		dependencies = {
			-- NOT A LUA MODULE
			-- "hrsh7th/vscode-langservers-extracted",
			"luals/lua-language-server",
			"hrsh7th/nvim-cmp"
		},
		config = function()
			local nvim_command = vim.api.nvim_command

			--Enable (broadcasting) snippet capability for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local cmpOk, cmp = pcall(require, "cmp")
			if cmpOk then
				local capabilitiesNvimCmp = require('cmp_nvim_lsp').default_capabilities()
				capabilities = vim.tbl_extend("force", capabilities, capabilitiesNvimCmp)
			end
			  capabilities.textDocument.completion.completionItem.snippetSupport = true

			local lspconfig = require("lspconfig")

			-- c/cc servers
			---------------------------------------
			-- TODO: [October 18, 2023] Setup ccls toolin
			-- see https://github.com/MaskRay/cclsg
			-- comparison to clangd: https://github.com/MaskRay/ccls/issues/880
			-- lspconfig.clangd.setup({})
			lspconfig.ccls.setup({ capabilities = capabilities, on_attach = on_attach })

			local lspconfig_efm = require("hinell.plugins.lsp.servers.efm"):init({
				capabilities = capabilities,
				on_attach = function()
					-- do not attach navic over here
				end
			})
			lspconfig.efm.setup(lspconfig_efm)
			lspconfig.jsonls.setup(require("hinell.plugins.lsp.servers.jsonls"):init({ capabilities = capabilities ,on_attach = on_attach }))
			lspconfig.yamlls.setup(require("hinell.plugins.lsp.servers.yamlls"):init({ capabilities = capabilities ,on_attach = on_attach }))
			lspconfig.bashls.setup(require("hinell.plugins.lsp.servers.bashls"):init({ capabilities = capabilities ,on_attach = on_attach }))

			-- Web servers
			---------------------------------------
			-- lspconfig.eslint.setup({})
			-- lspconfig.tsserver.setup(require("hinell.plugins.lsp.servers.tsserver"):init({ on_attach = on_attach }))
			lspconfig.html    .setup({ capabilities = capabilities ,on_attach = on_attach })
			lspconfig.cssls   .setup({ capabilities = capabilities ,on_attach = on_attach })
			lspconfig.sqlls   .setup({ capabilities = capabilities ,on_attach = on_attach })
			lspconfig.vimls   .setup({ capabilities = capabilities ,on_attach = on_attach })
			-- Lua webservers
			---------------------------------------
			local lspconfig = require("lspconfig")
			-- Path to lua-language-server
			local llsPaths = {
				-- v3.9.3
				-- v3.13.9
				vim.env.HOME .. "/.local/share/nvim/lazy/lua-language-server/bin/lua-language-server",
			}
			local llsExecFound = false;
			local llsPath = ""
			for i, _path in pairs(llsPaths) do
				llsExecFound = uv.fs_stat(_path) and true or false
				if llsExecFound then
					llsPath = _path
					break
				end
			end

			if llsExecFound then
				lspconfig.lua_ls.setup({
					capabilities = capabilities
					, cmd = { llsPath }
					-- This should be configured via .luarc.json
					-- runtime = { version = "LuaJIT" },
					, on_attach = on_attach
				})
			else
				vim.notify("lua-language-server isn't found, skipping!", vim.log.levels.WARN)
			end

			require("hinell.plugins.lsp.servers.emmet"):init(pm, { capabilities = capabilities ,on_attach = on_attach })

		end
	})

	-- Generatoe .gitignore
	-- TODO: [May 12, 2023] Install & Setup Symbol overview
	-- Replaced by https://github.com/stevearc/aerial.nvim ?
	use({ "simrat39/symbols-outline.nvim" })

	use({
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		version = "latest",
		init = function(opts)
			-- vim.g["lsp-timeout-config"] = {
			vim.g.lspTimeoutLoaded = false
			vim.g.lspTimeoutConfig = {
				-- stopTimeout  = 1000 * 4, -- ms, timeout before stopping all LSP servers
				-- startTimeout = 1000 * 4,  -- ms before restart
				-- silent       = true, -- true to suppress notifications
				-- filetypes = {
				-- 	ignore = {
						-- "lua"
						-- "markdown"
						-- "tsx",
						-- "typescript.tsx"
					-- }
				-- }
			}
		end,
	})

	use({
		"creativenull/efmls-configs-nvim",
		tag = 'v1.x.x',
		dependencies = { 'neovim/nvim-lspconfig' }
	})

	use({
		enabled = true,
		"pmizio/typescript-tools.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({})
			require("lspconfig")["typescript-tools"].setup({
				on_attach = on_attach,
				filetypes = {
					"javascript",
					"js",
					"jsm",
					"jsx",
					"ts",
					"tsx",
					"typescript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				}

			})
		end
	})

	-- Bind to LazyDone sub-event
	autocmd({
		"User"
	},{
		pattern  = "LazyDone",
		once     = false,
		callback = function(auEvent)
			M.legendary:init({ bufnr = nil })
		end
	})

	require("hinell.plugins.lsp.diagnostics"):init()
	require("hinell.plugins.lsp.lsp-progress"):init(pm)
	-- NOTE: [October 30, 2023] Legacy; remove in next revision; only for tests
	-- require("hinell.plugins.lsp.servers.none-ls"):init(pm)
end

return M
