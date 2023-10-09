-- TODO: [December 07, 2023] Move to a library
-- TODO: [December 07, 2023] Add opts to be provided to jit.p
-- TODO: [December 07, 2023] Add optional Trace Event Format; ref: https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/preview#heading=h.yr4qxyxotyw
local M = {}
-- Export user commands
M.nvim = require("nvim-api")

M.jit = {}
M.jit._counter = 1
-- M.jit._animation_frames = { "/", "\\" }
M.jit._animation_frames = { "⠧", "⠏" , "⠛" , "⠹" , "⠼" , "⠶" }
M.jit._animation_frames_size = #M.jit._animation_frames

--- Return string status on whether jit profiler is running or not
--- @return string
function M.jit.status()
	if M.jit._running then
		local spinner = M.jit._animation_frames[M.jit._counter % M.jit._animation_frames_size + 1]
		M.jit._counter = M.jit._counter + 1
		return "[PROFILER " .. spinner .. "]"
	else
		return ""
	end
end


--- @class hinell.profiler.jit.opts
--- @field bang boolean|nil Reserved
--- @field silent boolean|nil supress extra notifications
--- @field filepath string|nil output file path, relative cwd-relative file

--- Start profiling
--- @param opts hinell.profiler.jit.opts|nil
function M.jit:start(opts)
	if self._running then return end
	opts = opts or {}
	opts = opts or {}
	local bang = opts.bang
	-- LuaFormatter off
	if not jit then
		vim.notify_once("LuaJIT is not supported on your platform."
		.. "Please, reach out to the Neovim and the LuaJIT technical support!")
		return
	end
	-- LuaFormatter on
	local cwd = vim.fn.getcwd()
	local profiling_file = opts.filepath
	if type(profiling_file) == "string" and profiling_file == ""  then
		profiling_file = vim.env.PROFILER_FILE_NAME
	end
	if type(profiling_file) ~= "string" then
		profiling_file = "jit.profile.txt"
		-- vim.notify("hinell:profiler:jit: profiling file name is required!", vim.log.levels.ERROR)
	end
	self.output_path = cwd  .. "/" .. profiling_file
	vim.notify("hinell:profiler: writing to " .. self.output_path, vim.log.levels.INFO)
	require("jit.p").start("10,F,i1,s,m0", vim.fn.getcwd() .. "/" .. profiling_file)
	self._running = true
end

--- Stop profiling
--- @param opts hinell.profiler.jit.opts|nil
function M.jit:stop(opts)
	opts = opts or {}
	if not self._running then
		if not opts.silent then
			vim.notify("hinell: profiler: not running - nothing to stop.", vim.log.levels.DEBUG)
		end
		return
	end

	self._counter = 1
	self._running = false
	-- local bang = args.bang
	local cwd = vim.fn.getcwd()
	vim.notify("hinell:profiler: written to "  .. self.output_path, vim.log.levels.INFO)
	require("jit.p").stop()
end


function M.jit:toggle(opts)
	if self._running then
		self:stop(opts)
	else
		self:start(opts)
	end
end

M.jit.autocmds = {}
table.insert(M.jit.autocmds, {
	{
		"VimLeave"
	},{
		pattern  = "*",
		once     = true,
		group    = "JITProfiler",
		callback = function(auEvent)
			M.jit:stop()
		end
	}
})

M.jit.commands = {}

table.insert(M.jit.commands, {
	name   = "JITProfilerStart",
	action = function(args) M.jit:start({ filepath = args.args }) end,
	opts = {
		desc  = "Start LuaJIT built in profiler",
		force = true,
		bar   = true,
		nargs = "?"
		-- complete = function() end
		-- preview = function() end
	}
})

table.insert(M.jit.commands, {
	name   = "JITProfilerStop",
	action = function(args) M.jit:stop(args) end,
	opts = {
		desc  = "Start LuaJIT built in profiler",
		force = true,
		bar   = true,
		nargs = "?"
		-- complete = function() end
		-- preview = function() end
	}
})

table.insert(M.jit.commands, {
	name   = "JITProfilerToggle",
	action = function(args) M.jit:toggle({ filepath = args.args }) end,
	opts = {
		desc  = "Start LuaJIT built in profiler",
		force = true,
		bar   = true,
		nargs = "?"
		-- complete = function() end
		-- preview = function() end
	}
})

M._enabled = false
--- Enable or disable Profiler commands & autocommands
function M.toggle(self)
	if self._enabled then
		self._enabled = false
		vim.notify("Profiler is disabled", vim.log.levels.INFO)
	else
		self._enabled = true
		vim.notify("Profiler is enabled", vim.log.levels.INFO)
	end
	M.nvim.commands:toggle(M.jit.commands)
	M.nvim.autocmds:toggle(M.jit.autocmds)
end

return M
