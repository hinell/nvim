-- @module M
-- M
-- Markdown previw plugin
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use

	-- Markdown preview plugin
	-- Requires node.js / npm
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_filetypes = {"markdown"}
			local legendaryIsOk, legendary = pcall(require, "legendary")
			local auCmdCallback =  function(opts)
				local legendary = require("legendary")
				local opts = { buffer = opts.buf  }
				legendary.funcs({
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
				})
			end

			if legendaryIsOk then
				legendary.autocmd({
					"FileType",
					opts = { pattern = {"markdown"} },
					auCmdCallback
				})
			end

		end
	})
end

return M
