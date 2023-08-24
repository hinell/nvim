local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	use({
		"LukasPietzschmann/telescope-tabs",
		config = function()
			require("telescope-tabs").setup({
				entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
					local cwd = vim.fn.getcwd()
					local entry_string = table.concat(vim.tbl_map(function(v)
						-- return v:gsub(cwd .. "/", "./")
						return vim.fn.fnamemodify(v, ":.")
					end, file_paths), ', ')
					return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
				end,
				entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
					return table.concat(file_paths, ' ')
				end
			})
		end
	})

end

return M
