-- @module M
-- M
-- Markdown previw plugin
local M = {}

M.init = function(self, pm)
	local use = pm.use

	-- Markdown preview plugin
	-- Requires node.js / npm
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }


		end
	})


	local augroup = vim.api.nvim_create_augroup
	local auclear = vim.api.nvim_clear_autocmds
	local autocmd = vim.api.nvim_create_autocmd
	local auGroup = augroup("markdownPreview", { clear = true })

	autocmd({
		"FileType"
	},{
		-- pattern  = { "*.md" },
		once     = true,
		group    = auGroup,
		callback = function(auEvent)

			local legendaryIsOk, legendary = pcall(require, "legendary")
			if not legendaryIsOk then
				error(legendary)
			end

			local opts = {}
			local funcs = {
				{
					description = "Editor: markdown: preview (plugin)",
					function() vim.cmd("MarkdownPreview") end,
					opts = opts
				}, {
					description = "Editor: markdown: preview stop (plugin)",
					function() vim.cmd("MarkdownPreviewStop") end,
					opts = opts
				}, {
					description = "Editor: markdown: preview toggle (plugin)",
					function() vim.cmd("MarkdownPreviewToggle") end,
					opts = opts
				}
			}
			legendary.funcs(funcs)
		end
	})
end

return M
