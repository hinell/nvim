-- You should also specify efm server as
-- preferred in vim.lsp.buf.format({  filter = ... })
-- vim.opt_local.formatprg = "stylua -"
vim.opt_local.formatprg = "lua-format"
vim.opt_local.makeprg   = "make"
vim.opt_local.formatoptions:remove("o")
