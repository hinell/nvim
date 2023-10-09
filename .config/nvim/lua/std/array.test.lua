local std = require("std")
local Array = std.Array

--- @class Array2
local Array2 = Array:subclass(function(self, super, arg)
	local instance = super:new(arg)
	return instance
end)

a = Array2:new()
assert(a.constructor == Array2,string.format("[[%s]]: %s %s", "array.test.lua", "a expected Array2 constructor, got", a.constructor))


print(("debug: %s: testing array in eval"):format(debug.getinfo(1).source))
for key, value in pairs(a) do
	print(vim.inspect({ key, value }))
end
