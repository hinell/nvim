-- @module M
-- M
-- Various dev utils
local M = {}

M.init = function (self, packer, legendary)
	local use = packer.use
	use({
		"ibhagwan/ts-vimdoc.nvim"
	})

	require("hinell.plugins.utils.markdown"):init(packer, legendary)
end

return M
