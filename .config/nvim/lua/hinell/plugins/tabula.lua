-- Testing Tabular-plugin-like commands 
-- vim.api.nvim_create_user_command("Tabula", "!column -t -s = -o = -R 1", { desc = "Align lines around <arg> char" , nargs=1, range=true })
vim.api.nvim_create_user_command("Tabula", function(ctx) print(ctx.args) end, { desc = "Align lines around <arg> char" , nargs="?", range=true })
-- vim.api.nvim_create_user_command("Print", "!printf '%%s' 'This is from terminal!'", { desc = "Align lines around <arg> char" , nargs=0, range=true, filter })

