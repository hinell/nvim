-- @module M
-- M
-- Markdown previw plugin
local M = {}

M.legendary = {}
M.legendary.register = function(legendary)
	legendary.autocmds({
		{
			"FileType",
			opts = {pattern = {"markdown"}},
			function()
				legendary.setup({
					funcs = {
						{
							description = "Buffer: markdown: preview (plugin)",
							function() vim.cmd("MarkdownPreview") end
						}, {
							description = "Buffer: markdown: preview stop (plugin)",
							function() vim.cmd("MarkdownPreviewStop") end
						}, {
							description = "Buffer: markdown: preview toggle (plugin)",
							function() vim.cmd("MarkdownPreviewToggle") end
						}
					}
				})
			end
		}
	})
end

M.packer = {}
M.packer.register = function(packer)
	local use = packer.use
	-- Markdown preview plugin
	-- Requires node.js / npm
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = {"markdown"} end,
		ft = {"markdown"}
	})
end

M.init = function(self, packer, legendary)
	self.packer.register(packer)
	self.legendary.register(legendary)
end
return M
