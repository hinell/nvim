-- TODO: [December 07, 2023] Move to a library
-- TODO: [December 07, 2023] Add opts to be provided to jit.p
-- TODO: [December 07, 2023] Add optional Trace Event Format; ref: https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/preview#heading=h.yr4qxyxotyw
local M = {}

M.jit = {}
M.jit._counter = 1
-- M.jit._animation_frames = { "/", "\\" }
M.jit._animation_frames = { "⠧", "⠏" , "⠛" , "⠹" , "⠼" , "⠶" }
M.jit._animation_frames_size = #M.jit._animation_frames


-- LuaFormatter off
--- For detailed description of flags below, see
--- https://luajit.org/ext_profiler.html#j_p
--- @class jit.profiler.ConfInstance:
--- @field filepath string? output file path, relative cwd-relative file
--- @field silent boolean? supress extra notifications
--- @field bang boolean? Reserved
--- @field f boolean?		-- f — dumps: function name, otherwise module:line. default
--- @field F boolean?		-- F — dumps: same as f, but dump module:name.
--- @field l boolean?		-- l — dumps: module:line.
--- @field depth number?	-- dumps depth (callee ← caller). Default: 1.
--- @field depthI number?	-- Inverse dumps depth (caller → callee).
--- @field s boolean?		-- s — split dumps after first stack level. Implies depth ≥ 2 or depth ≤ -2.
--- @field p boolean?		-- p — Show full path for module names.
--- @field V boolean?		-- v — Show VM states.
--- @field Z boolean?		-- z — Show zones.
--- @field r boolean?		-- r — Show raw sample counts. Default: show percentages.
--- @field a boolean?		-- a — Annotate excerpts from source code files.
--- @field A boolean?		-- A — Annotate complete source code files.
--- @field G boolean?		-- G — Produce raw output suitable for graphical tools.
--- @field m number?		-- m<number> — Minimum sample percentage to be shown. Default: 3%.
--- @field i number?		-- i<number> — Sampling interval in milliseconds. Default: 10ms.
M.conf = {
	 filepath= nil
	,bang    = nil
	,silent  = false

	,depth   = 10
	,depthI  = nil
	,f = true
	,F = false
	,l = false
	,s = true
	,p = true
	,V = false
	,Z = false
	,r = false
	,a = false
	,A = false
	,G = false
	,m = 3
	,i = 50
}
-- LuaFormatter on

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



--- Start profiling
--- @param conf jit.profiler.ConfInstance|nil
function M.jit:start(conf)
	if self._running then return end
	conf = vim.tbl_extend("keep", conf or {}, M.conf)
	local bang = conf.bang
	-- LuaFormatter off
	if not jit then
		vim.notify_once("LuaJIT is not supported on your platform."
		.. "Please, reach out to the Neovim and the LuaJIT technical support!")
		return
	end
	-- LuaFormatter on
	local cwd = vim.fn.getcwd()
	local profiling_file = conf.filepath
	if type(profiling_file) == "string" and profiling_file == ""  then
		profiling_file = vim.env.PROFILER_FILE_NAME
	end
	if type(profiling_file) ~= "string" then
		profiling_file = "jit.profile.txt"
		-- vim.notify("jit.profiler:jit: profiling file name is required!", vim.log.levels.ERROR)
	end
	self.output_path = cwd  .. "/" .. profiling_file

	-- "10pi10sm3"
	local mode = ""

	if type(conf.depth) == "number" then
		mode = mode .. conf.depth
	else
		mode = mode .. M.conf.depth
	end

	if type(conf.depthI) == "number" then
		mode = mode .. conf.depthI
	end

	local modeFlags = { "f", "F", "l", "s", "p", "V", "Z", "r", "a", "A", "G" }
	for i, flag in ipairs(modeFlags) do
		if conf[flag] then
			mode = mode .. flag
		end
	end

	if type(conf.i) == "number" then mode = ("%si%s"):format(mode, conf.i) end
	if type(conf.m) == "number" then mode = ("%sm%s"):format(mode, conf.m) end

	-- print(vim.inspect({ "mode", mode }))
	vim.notify("jit.profiler: writing to " .. self.output_path, vim.log.levels.INFO)
	require("jit.p").start(mode, vim.fn.getcwd() .. "/" .. profiling_file)
	self._running = true
end

--- Stop profiling
--- @param conf jit.profiler.ConfInstance|nil
function M.jit:stop(conf)
	conf = conf or {}
	if not self._running then
		if not conf.silent then
			vim.notify("hinell: profiler: not running - nothing to stop.", vim.log.levels.DEBUG)
		end
		return
	end

	self._counter = 1
	self._running = false
	-- local bang = args.bang
	local cwd = vim.fn.getcwd()
	vim.notify("jit.profiler: written to "  .. self.output_path, vim.log.levels.INFO)
	require("jit.p").stop()
end


function M.jit:toggle(conf)
	if self._running then
		self:stop(conf)
	else
		self:start(conf)
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
table.insert(M.jit.commands, {
	name   = "JITProfilerStatus",
	action = function(args) print(("%s: status: %s"):format("JITProfiler", M.jit._running and "running" or "stopped")) end,
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
	local nvimOk, nvim = pcall(require, "nvim-api")
	assert(nvimOk, "JITProfiler: nvim-api.nvim module is not loaded or found, please, make sure toggle() is called after plugins are loaded")
	M.nvim = nvim

	if self._enabled then
		self._enabled = false
		vim.notify("JITProfiler: disabled", vim.log.levels.INFO)
	else
		self._enabled = true
		vim.notify("JITProfiler: enabled", vim.log.levels.INFO)
	end
	M.nvim.commands:toggle(M.jit.commands)
	M.nvim.autocmds:toggle(M.jit.autocmds)
end

--- Setup autocmds for profiler
--- @param self any
--- @return nil
M.init = function (self)

	local this = self
	local augroup = vim.api.nvim_create_augroup
	local autocmd = vim.api.nvim_create_autocmd
	local auGroup = augroup("UserJITProfiler", { clear = true })
	autocmd({
			"VimEnter"
		},{
			once     = true,
			group    = auGroup,
			callback = function(auEvent)
				this:toggle()
			end
	})

end

return M
