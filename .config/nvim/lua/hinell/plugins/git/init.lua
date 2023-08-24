--- @module git
--- git related plugins config
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
	require("hinell.plugins.git.diffview").packer:register(packer)
	require("hinell.plugins.git.gitsigns").packer:register(packer)
end

M.legendary = {}
M.legendary.init = function (self, legendary)
	require("hinell.plugins.git.diffview").legendary:init(legendary)
end

return M
