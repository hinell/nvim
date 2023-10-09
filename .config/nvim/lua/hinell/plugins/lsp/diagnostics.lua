-- See also: LspAttach at
-- .config/nvim/lua/hinell/plugins/lsp/init.lua
local M = {}

M.legendary = {}
M.legendary.keymap = {}
M.legendary.keymap.diagnostics = {
	  {  mode = { "n" }, description = "Diagnostics: go to next", '[d', vim.diagnostic.goto_prev }
	, {  mode = { "n" }, description = "Diagnostics: go to next", ']d', vim.diagnostic.goto_next }
}

M.legendary.funcs = {
	{ description = "lsp: diagnostics: hide", vim.diagnostic.hide  },
	{ description = "lsp: diagnostics: show", vim.diagnostic.show  }
}

M.symbols = {
	error    = " ",
	warn     = " ",
	info     = " ",
	hint     = " ",
	unknown  = "� ",
}
M.init = function (self)

	-- Setup symbols
	vim.fn.sign_define("DiagnosticSignError"  , { text = M.symbols.error })
	vim.fn.sign_define("DiagnosticSignWarn"   , { text = M.symbols.warn })
	vim.fn.sign_define("DiagnosticSignInfo"   , { text = M.symbols.info })
	vim.fn.sign_define("DiagnosticSignHint"   , { text = M.symbols.hint })
	vim.fn.sign_define("DiagnosticSignUnkown" , { text = M.symbols.unknown })

	-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#customize-lsp-codelens-and-signs
	vim.diagnostic.config({
		virtual_text = {
			source = "always",
			prefix = "‣",
			severity = {
				-- min = vim.diagnostic.severity.WARN
				min = vim.diagnostic.severity.ERROR
			},
		},
		float = {
			source = "always",
			-- border = "rounded",
		},
		signs            = true,
		underline        = true,
		update_in_insert = false,
		severity_sort    = true,
	})


	local augroup = vim.api.nvim_create_augroup
	-- local auclear = vim.api.nvim_clear_autocmds
	local autocmd = vim.api.nvim_create_autocmd

	local auGroupDiagnID       = augroup("LPDiagnostics"       , { clear = true })
	local auGroupDiagnBufferID = augroup("LSPDiagnosticsBuffer", { clear = true })
	autocmd({
			"LspAttach"
		},{
			once     = false,
			group    = auGroupDiagnID,
			callback = function(auAttachEvent)

				local bufnr = auAttachEvent.buf
				-- BUG: this is buggy!
				-- local _diagnosticsAreSetup = pcall(vim.api.nvim_buf_get_var, bufnr, "_diagnosticsAreSetup")
				--
				local _diagnosticsAreSetup = vim.b[bufnr]._diagnosticsAreSetup
				if _diagnosticsAreSetup then
					return
				end
				vim.b[bufnr]._diagnosticsAreSetup = true

				autocmd({ "CursorHold" },{
					buffer = bufnr,
					group = auGroupDiagnBufferID,
					callback = function(args)
						if _G.diagnosticsTimer then
							return
						end
						local uv = vim.uv or vim.loop
						local timer = uv.new_timer()
						timer:start(1000 * 30, 0, vim.schedule_wrap(function()
							vim.diagnostic.open_float()
							timer:stop()
							timer:close()
							_G.diagnosticsTimer = nil
						end))
						_G.diagnosticsTimer = timer
					end
				})
				local napiOk, napi = pcall(require, "nvim-api")
				if not napiOk then
					vim.notify("hinell diagnostics setup: nvim-api is not found. Aborting.", vim.log.levels.DEBUG)
					return
				end

				if napi.Buffer:hasKeymap(bufnr, "[d", "n") then return end
				local legendaryIsOk, legendary = pcall(require, "legendary")
				-- Bind locally
				for i, _keymap in pairs(M.legendary.keymap.diagnostics) do
					_keymap.opts = { buffer = bufnr }
				end
				for i, _func in pairs(M.legendary.funcs) do
					_func.opts = { buffer = bufnr }
				end

				if legendaryIsOk then
					legendary.keymaps({
						{
							itemgroup   = "LSP",
							keymaps     = M.legendary.keymap.diagnostics
						}
					})
					legendary.funcs({
						{
							itemgroup   = "LSP",
							funcs 		= M.legendary.funcs
						}
					})
				end
			end
	})

	autocmd({
			"LspDetach"
		},{
			pattern  = "*",
			group    = auGroupDiagnID,
			callback = function(auEventLD)

				local bufnr = auEventLD.buf
				local _diagnosticsAreSetup = vim.b[bufnr]._diagnosticsAreSetup
				if not _diagnosticsAreSetup then
					return
				end
				vim.b[bufnr]._diagnosticsAreSetup = false

				local napiOk, napi = pcall(require, "nvim-api")
				if not napiOk then
					vim.notify("hinell diagnostics setup: nvim-api is not found. Aborting.", vim.log.levels.DEBUG)
					return
				end
				if napi.Buffer:hasKeymap(bufnr, "[d", "n") then
					vim.keymap.del("n", "[d", { buffer = bufnr })
					vim.keymap.del("n", "]d", { buffer = bufnr })
					vim.b._diagnosticsAreSetup = false
				end

			end
	})

end
return M
