--- @module duplicate
-- M
-- hinell/duplicate.nvim config
local M = {}

M.packer = {}
M.packer.register = function(self, packer)
	local use = packer.use
    use({
        "hinell/duplicate.nvim"
    })
end

M.init = function(self, packer)
	local use = packer.use

end

return M
