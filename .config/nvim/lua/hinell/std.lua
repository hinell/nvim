-- Created-at: Wednesday, December 21, 2022
-- Lua standard classes implementing ECMA Script like standard library. All are globally scoped.
-- TODO: Rewrite by using classes/metatables
--------------------------------------------------------------------------String
String = { }
-- I'm inserting a string at specified position insider another one
-- @param str1 - Target string
-- @param pos  - Position at which to insert
-- @param str2 - String for insertion at pos
-- @return A str1 with inserted str2
String.insert = function (str1, pos, str2)
  return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

------------------------------------------------------------------------Function
-- A function class
-- @type Shape
-- @table Shape
Function = { prototype = {} }

--- Creates new instance static method)
-- @tparam  Table containing area
function Function:new (fn)
    local instance = {}
          instance.fn = fn
          instance.constructor = self
          setmetatable(instance, { __index = self.prototype })
    return instance
end

--- Bind a function to a certain argument and return a new function
-- @tparam arg0 ...
function Function.prototype:bind (...)
	local __args = { ... }
	local this = self
	return function(...)
		return this.fn(unpack(__args), ...)
	end
end


---------------------------------------------------------------------------Array
-- I'm a standard array class
-- @type Shape
-- @table Shape
Array = { prototype = {} }

--- Creates new instance static method)
-- @tparam  Table containing area
function Array:new (arrayInstance)
    local instance = arrayInstance or {}
          instance.arrayInstance = arrayInstance
          instance.constructor = self
          setmetatable(instance, { __index = self.prototype })
    return instance
end


--- Make a subclass of the given class. Returns a table with :new(...)
-- @usage ...:subclass(function(self, super, ...) return super:new(...) end)
-- @tparam function A constructor function
-- @treturn table
function Array:subclass (constructor)

    local super = self
    assert(constructor, "subclass: constructor is missing, please provide a function!")
    assert(type(constructor) == "function", "subclass: constructor is should be of function type!")

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
        return table.constructor.prototype[key]
            or table.constructor.super.prototype[key]
    end

    class.new = function(self, ...)
        local  instance = self:_new(self.super, ...)
               instance = instance or {}
               instance.constructor = self
               setmetatable(instance, class._mt)
        return instance
    end

    return class
end

--- Insert item at given position
-- @tparam number pos A position to insert at
-- @tparam any val A value to insert
function Array.prototype:insert (pos, val)
	table.insert(self, pos, val)
	return self
end

--- Push an item to the array
-- @tparam number pos A position to insert at
-- @tparam any val A value to insert
function Array.prototype:push (val)
	table.insert(self, val)
	return self
end
