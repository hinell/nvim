-- This class instance manages autocmds and reflects nvim api
-- Main methods are .toggle(), .enable(), and .disable()
-- It focuses on tables of autocmds instead of single tables
local M = {}

--- @param commands table
function M.enable(commands)
	if commands._enabled then return end
	commands._enabled = true
	-- LuaFormatter off
	for _, command_spec in ipairs(commands) do
		if command_spec[2].group then
			vim.api.nvim_create_augroup(command_spec[2].group, { })
		end
		local id = vim.api.nvim_create_autocmd(
			command_spec[1],
			command_spec[2]
		)
		command_spec.id = id
	end
end
--- @param commands table
function M.disable(commands)
	if not commands._enabled then return end
	local cleared_groups = {}
	-- LuaFormatter off
	for _, command_spec in ipairs(commands) do
		local already_cleared = cleared_groups[command_spec[2].group]
		if command_spec.id then
			vim.api.nvim_del_autocmd(command_spec.id)
		elseif command_spec[2].group and already_cleared then
			cleared_groups[command_spec[2].group] = true
			vim.api.nvim_clear_autocmds({ group = command_spec[2].group })
		end
	end
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
