-- This class instance manages user commands and reflects nvim api
-- Main methods are .toggle(), .enable(), and .disable()
-- It focuses on tables of autocmds instead of single tables
local M = {}
--- Enable all profiler commands
--- @diagnostic disable-next-line: duplicate-set-field
--- @param commands table
function M.enable(commands)
	if commands._enabled then return end
	commands._enabled = true
	-- LuaFormatter off
	for _, command_spec in ipairs(commands) do
		vim.api.nvim_create_user_command(
			command_spec.name,
			command_spec.action,
			command_spec.opts
		)
	end
	-- LuaFormatter on

end

--- Disable  all profiler commands
--- @param commands table
function M.disable(commands)
	if not commands._enabled then return end
	-- LuaFormatter off
	for _, command_spec in ipairs(commands) do
		vim.api.nvim_del_user_command( command_spec.name)
	end
	-- LuaFormatter on
	commands._enabled = false
end

--- Toggle nvim user commands
--- @param commands table
function M:toggle(commands)
	if commands._enabled then
		M.disable(commands)
	else
		M.enable(commands)
	end
end

return M
