-- Neo-tree plugin configuration
local M = {}

M.legendary = {} 
M.legendary.autocmds = { 
-- REMOVE: [March 25, 2023] neo-tree is memory inefficient, DO NOT USE IT 
-- This config was used to populate Legendary plugin list of shortcuts
--
	-- ,{
	-- 	"FileType",
	-- 	-- description = "neo-tree plugin integration", -- BUGGY
 --        opts = { pattern = "neo-tree", once = true },
	-- 	function(autoCmdEvent)
	-- 		local neoTreeKeymaps = {}
	-- 		local keymapsAdd = function(keymaps, mappings, keys, prefix, autoCmdEvent)
	-- 			for i, k in pairs(keys) do
	-- 				-- print("pairs loop:k => ", k, mappings[k])
	-- 				local description = mappings[k];
	-- 				if type(description) == "table" then
	-- 					description = description[1]
	-- 				end	 
	-- 				table.insert(keymaps, {
	-- 					k,
	-- 					mode = "n",
	-- 					description = prefix .. description,
	-- 					opts = { buffer = autoCmdEvent.buf }
	-- 				})
	-- 			end
	-- 		end
	-- 		-- DEBUG: [March 25, 2023] This consumes a lot of memory!
	--
	-- 		local maps = require("neo-tree.defaults").window.mappings
	-- 		keymapsAdd(neoTreeKeymaps, maps, vim.tbl_keys(maps), "neo-tree: ", autoCmdEvent)
	--
	-- 		local mapsfs = require("neo-tree.defaults").filesystem.window.mappings
	-- 		keymapsAdd(neoTreeKeymaps, mapsfs, vim.tbl_keys(mapsfs), "neo-tree: fs: ", autoCmdEvent)
	--
	-- 		local mapsgit = require("neo-tree.defaults").git_status.window.mappings
	-- 		keymapsAdd(neoTreeKeymaps, mapsgit, vim.tbl_keys(mapsgit), "neo-tree: git:", autoCmdEvent)
	--
	-- 		print(vim.inspect(neoTreeKeymaps))
	-- 		require("legendary").setup({
	-- 			keymaps = neoTreeKeymaps
	-- 			--[[ keymaps = {
	-- 				{ itemgroup="neo-tree: ", keymaps =  neoTreeKeymaps}
	-- 			} ]]
	-- 		})
	-- 	end
	-- }
}

return M
