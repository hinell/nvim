local M = {}

local packagePath = package.path;
package.path = package.path .. ";" .. vim.env.HOME .. "/.local/share/nvim/lazy/oop-std.lua/lua/?/init.lua"
package.path = package.path .. ";" .. vim.fn.stdpath("data") .. "/lazy/oop-std.lua/lua/?.lua"

local std = {}
	  std.Array = require("oop-std.Array")

package.path = packagePath


--- Plugis for lazy.nvim
--- @class M.Plugins
M.Plugins = std.Array:subclass(function(self, super, plugins)
	plugins = plugins or {}
	local instance = super:new(plugins)
	return instance
end)

--- Push plugin into the plugin list
--- @tparam table pluginSpec
--- @treturn nil
function M.Plugins.prototype:use(pluginSpec, options)
	local warn = function(pluginSpec, fn, renameTo)
		-- vim.notify(("%s plugin has %s function; rename it to %s"):format(pluginSpec[1], fn, renameTo), vim.log.levels.INFO)
		vim.api.nvim_echo({
		  { pluginSpec[1], "Special" },
		  { " plugin has a ", "Normal" },
		  { fn .. "=" , "MoreMsg" },
		  { " field; rename it to ", "Normal" },
		  { renameTo, "MoreMsg" }
		}, true, {  verbose = false  } )
	end
	self:push(pluginSpec)

	-- Packer to Lazy spec converter
	-- LuaFormatter off
	local specMap = {
		setup    = "init",
		run      = "build",
		requires = "dependencies",
		disable  = "enable",
		tag      = "version",
	}
	-- LuaFormatter on
	for from, to in pairs(specMap) do
		if pluginSpec[from] then
			pluginSpec[to] = pluginSpec[from]
			pluginSpec[from] = nil
			if options.warn then warn(pluginSpec, from, to) end
		end
	end
end

return M
