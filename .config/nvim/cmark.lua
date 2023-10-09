-- @module cmark
--- Description.........: Test of a cmark (written in c) markdown parser in lua!
--- Runtime Dependencies: ! sudo apt install libcmark0.30.2 libcmark-dev
--- Created-at: May 14, 2023
--- @module ''
--- @Usage: see below
--
-- TODO: [May 14, 2023] Move to a plugin, see also for reference:
-- https://github.com/jgm/cmark-lua

--- Cmark document
local Document = { prototype = {} }


--- Default context: std apis for internal class
Document.ctx = {}
local ffiLoaded		, ffi	= assert(pcall(require, "ffi"))

-- See /usr/include/cmark.h for more info
vim.fn.setenv("CMARK_OPT_UNSAFE", false)
ffi.cdef([[
char *cmark_markdown_to_html(const char *text, size_t len, int options);
]])
-- TODO: [May 14, 2023] Make cross-platform
local cmarkLoaded	, cmark	= assert(pcall(ffi.load, "cmark"))
if not cmarkLoaded then
	vim.notify("cmark loading failed!", vim.log.levels.ERROR)
end
-- error "cmark0.30.2 module is not found"
Document.ctx.ffi	= ffi
Document.ctx.cmark	= cmark
Document.ctx.io		= io

--- Commonmark Source File that can be used for various tasks
--- @tparam path string Path to a markdown file
--- @param ctx table Table with default classes, see CmarSource.ctx above
function Document:new (path, ctx)
			assert(path, "[CmarkSource]: invalid argument, path is required!")
	local	instance = {}
		 	instance.path = path
		 	instance.constructor = self
		 	setmetatable(instance, { __index = self.prototype })
			instance.ctx = vim.tbl_extend("force", self.ctx, ctx or {})
	return	instance
end


--- Make a subclass of the given classsel. Returns a table with :new(...)
-- @usage ...:subclass(function(self, super, ...) return super:new(...) end)
-- @tparam function A constructor function
-- @treturn table
function Document:subclass (constructor)

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
--- Description
--- @tparam type param
function Document.prototype:toHTML()

	local	ffi      = self.ctx.ffi
	local	io       = self.ctx.io
	local	input    = assert(io.open(self.path))
	local	inputStr = input:read("*a")

	local len = ffi.new("size_t", inputStr:len())
	local html = cmark.cmark_markdown_to_html(inputStr, len, 0)
	input:close()
	return ffi.string(html)
end

Document.htmlDocumentTemplate = [[
<!DOC>
<html>
	<head>
	<title>%s</title>
	</head>
	%s
	<body>
	</body>
</html>
]]
--- Convert Markdown source into an html
--- @tparam string path
function Document.prototype:toHTMLFile (path, templateString)

	assert(path, "[CmarkSource]: invalid argument, path is required!")
	templateString = templateString or self.constructor.htmlDocumentTemplate
	local	io  = self.ctx.io
	local	output = io.open(path, "w")
	local	htmlString = ffi.string(self:toHTML())
	local r = output:write(templateString:format(self.path, htmlString))
	output:close()
	return r
end

local readme = Document:new("./README.md")
print(readme:toHTMLFile("./README.html"))
