local M = {}
-- Created-at: Wednesday, December 21, 2022
-- Lua standard classes implementing ECMA Script like standard library. All are globally scoped.
-- TODO: [January 1, 2023] Rewrite by using classes/metatables

--- LuaDoc notation are based on EmmyLua/LuaCats and used by lua-language-server
--- @see https://github.com/LuaLS/lua-language-server/wiki/Annotations

--- @alias std.subclassConstructorCb<TS> fun(super: TS,...): ...
--- @alias std.subclassFn<TS, TR> fun(self: TS, cb: std.subclassConstructorCb<TS>): TR

--------------------------------------------------------------------------String
M.String = { }
M.String.Array = M.Array -- Array constructor
--- Insert string at given position insider another one
--- @param pos number - Position at which to insert
--- @param str string - String to be inserted
--- @return string string an inserted string
function M.String:insert (pos, str2)
  return self:sub(1,pos)..str2..self:sub(pos+1)
end


--- Split string and return an array
--- Credits to http://lua-users.org/wiki/SplitJoin
--- @param strOrPattern string String or lua pattern
--- @return string[]
function M.String:split(strOrPattern)
	local Array = M.String.Array
	local outputArr = Array and Array:new() or {}
	local matchPosStartLast = 1
	local matchPosStart, matchPosEnd = string.find(self, strOrPattern, matchPosStartLast )
	local matchStr = ""
	while matchPosStart do
		-- print(vim.inspect({ matchPosStart, matchPosEnd }))
		matchStr = string.sub(self, matchPosStartLast, matchPosStart - 1 )
		print(vim.inspect({ matchPosStartLast, matchPosStart - 1  }))
		matchPosStartLast = matchPosEnd + 1
		table.insert( outputArr, matchStr )
		matchPosStart, matchPosEnd = string.find(self, strOrPattern, matchPosStartLast )
	end
	table.insert( outputArr, string.sub(self, matchPosStartLast ) )
	return outputArr
end

------------------------------------------------------------------------Function
-- A function class
--- @ype Function
--- @able Function
-- @field prototype

M.Function = { prototype = { constructor = M.Function } }

--- Creates new instance static method)
--- @param  Table containing area
function M.Function:new (fn)
    local instance = {}
          instance.fn = fn
          setmetatable(instance, { __index = self.prototype })
    return instance
end

--- Bind a function to a certain argument and return a new function
--- @param arg0 ...
function M.Function.prototype:bind (...)
	local __args = { ... }
	local this = self
	return function(...)
		return this.fn(unpack(__args), ...)
	end
end


---------------------------------------------------------------------------Array

--- @class std.ArrayInstance
--- @field constructor std.Array
--- @field insert fun(self, item: any): std.ArrayInstance
--- @field push fun(self, item: any): std.ArrayInstance
--- @field concat fun(self, stringOrTable: string|table|std.ArrayInstance): string|std.ArrayInstance
--- @field join fun(self, sep: string|nil): string

--- Like table, but array
--- @class std.Array
--- @field new fun(self, table: table|nil): std.ArrayInstance
--- @field subclass fun(self, cb: std.subclassConstructorCb): table
--- @field prototype std.ArrayInstance

--- @alias std.Table std.Array

--- @type std.Array
--- @diagnostic disable-next-line: missing-fields
M.Array = { prototype = { constructor = M.Array } }

-- --- @class std.TestInstance
-- --- @class std.Test: std.Array
-- --- @field wtf string
-- --- @field new fun(self, table: table|nil): std.TestInstance
-- local TEST = M.Array:subclass(function(super) end)
--
-- TEST:

--- Creates new instance static method)
--- @param self std.Array
--- @param table table
function M.Array:new (table)
    local instance = type(table) ~= "table" and table or {}
          setmetatable(instance, { __index = self.prototype })
    return instance
end

--- Make a subclass of the given class. Returns a table with :new(...)
--- @usage ...:subclass(function(self, super, ...) return super:new(...) end)
--- @param constructor std.subclassConstructorCb
--- @return table
function M.Array:subclass (constructor)

    local super = M.Array
    assert(constructor, "subclass: constructor is missing, please provide a function!")
    assert(type(constructor) == "function", "subclass: constructor should a function!")

    -- class = class or {}
    local class = {}
    class._new = constructor or function() end
    class.subclass = self.subclass
    class.super = super
    class.prototype = class.prototype or {}
    class.prototype.constructor = class
    if not merge then
        if vim then
            merge = function(a, b)
                return vim.tbl_extend("force", a, b)
            end
        end
    end
    class._mt = {}
    class._mt.__index = function(table, key)
		if key == "constructor" then return class end
        return table.constructor.prototype[key]
            or table.constructor.super.prototype[key]
    end

    class.new = function(self, ...)
        local  instance = self:_new(self.super, ...)
               instance = instance or {}
               -- instance.constructor = self
               setmetatable(instance, self._mt)
        return instance
    end

    return class
end

--- Insert item at given position
--- @param number pos A position to insert at
--- @param any val A value to insert
function M.Array.prototype:insert (pos, val)
	table.insert(self, pos, val)
	return self
end

--- Push an item to the array
--- @param pos A position to insert at
--- @param any val A value to insert
function M.Array.prototype:push (val)
	table.insert(self, val)
	return self
end

--- Concat array by using a string into string
--- or concat into a bigger new Array instance if table provided
--- @param tableOrString table|string
--- @return string|std.Array
function M.Array.prototype:concat(tableOrString)
	if type(tableOrString) == "table" then
		local self_obj = vim.list_extend({}, self)
		return self.constructor:new(vim.list_extend(self_obj, tableOrString))
	elseif type(tableOrString) == "string" then
		return table.concat(self, tableOrString)
	else
		return ""
	end
end
--- Join array's elements by separator string
--- @param sep string
--- @return string
function M.Array.prototype:join(sep)
	return table.concat(self, sep)
end

--- Stack; jsut like array, but you can pop as well
M.Stack = M.Array:subclass(function(self, super, table)
	local instance = super:new(table)
	return instance
end)

--- Returns length/size of the stack
--- @return number
function M.Stack.prototype:size()
	return #self
end
--- Push value onto  a stack
--- @param value *
--- @return *
function M.Stack.prototype:push (value)
	self[#self + 1] = value
	return value
end


--- Pop value off the stack
--- @param value *
--- @return *
function M.Stack.prototype:pop (value)
	local value = self[#self]
	self[#self] = nil
	return value
end

return M
