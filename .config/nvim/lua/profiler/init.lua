-- TODO: [December 07, 2023] Move to a separate plugin
-- TODO: [December 07, 2023] Add optional Trace Event Format; ref: https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/preview#heading=h.yr4qxyxotyw

--- @param ... table
local tblExtend = function(...)
	return vim.tbl_extend("keep", ...)
end
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
	 filepath= "jit.profile.txt"
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
	conf = tblExtend(conf or {}, M.conf)
	local bang = conf.bang
	-- LuaFormatter off
	if not jit then
		vim.notify_once("LuaJIT is not supported on your platform."
		.. "Please, reach out to the Neovim and the LuaJIT technical support!")
		return
	end
	-- LuaFormatter on
	local profiling_file = conf.filepath
	if type(profiling_file) == "string" and profiling_file == ""  then
		profiling_file = vim.env.PROFILER_FILE_NAME
	end
	if type(profiling_file) ~= "string" then
		profiling_file = M.jit.conf.filepath
		-- vim.notify("jit.profiler:jit: profiling file name is required!", vim.log.levels.ERROR)
	end

	local cwd = vim.fn.getcwd()
	self.output_path = vim.fs.joinpath(cwd,profiling_file)

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


--- @param conf jit.profiler.ConfInstance
function M.jit:toggle(conf)
	if self._running then
		self:stop(conf)
	else
		self:start(conf)
	end
end

--- Open the output file in editor; when not running
--- @return nil
function M.jit:show()
	if type(self.output_path) ~= "string" then
		return
	end
	vim.uv = vim.uv or vim.loop
	vim.uv.fs_stat(self.output_path,function(err, stat)
		if err then
			error(err, 2)
			return
		end
		vim.schedule(function()
			vim.cmd.tabnew(self.output_path)
		end)
	end)

end

-- When vim is closed - stop profiler and write file
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

-- User commands to be enabled/disabled
M.jit.commands = {}

table.insert(M.jit.commands, {
	 "JITProfiler",
	 function(args)

		 local filepath = args.fargs[2]
		 if args.fargs[1]:match("start") then
			 M.jit:start({ filepath = filepath })

		 elseif args.fargs[1]:match("stop") then
			 M.jit:stop({ filepath = filepath })

		 elseif args.fargs[1]:match("toggle") then
			 M.jit:toggle({ filepath = filepath })

		 elseif args.fargs[1]:match("status") then
			 print(("%s: status: %s"):format("JITProfiler", M.jit._running and "running" or "stopped"))
		 elseif args.fargs[1]:match("show") then
			 M.jit:show()
		 end

	 end,
	 {
		 force = true,
		 bar   = true,
		 nargs = "+",
		 desc  = "LuaJIT built in profiler command",
		 complete = function(lead, line, pos)
			 return {
				 "start",
				 "start jit.profile.txt",
				 "stop",
				 "show",
				 "toggle",
				 "status"
			 }
		 end
	 }

})

M._enabled = false
--- Enable or disable Profiler commands & autocommands
function M.toggle(self)
	local autocmdsOk, Autocmds = pcall(require, "nvim-api.Autocmds")
	local usrcmdsOk, Commands = pcall(require, "nvim-api.Commands")
	assert(autocmdsOk, "JITProfiler: nvim-api.nvim module is not loaded or found, please, make sure toggle() is called after plugins are loaded")
	assert(usrcmdsOk, "JITProfiler: nvim-api.nvim module is not loaded or found, please, make sure toggle() is called after plugins are loaded")

	M.Autocmds = Autocmds
	M.Commands = Commands

	if self._enabled then
		self._enabled = false
		vim.notify("JITProfiler: disabled", vim.log.levels.INFO)
	else
		self._enabled = true
		vim.notify("JITProfiler: enabled", vim.log.levels.INFO)
	end

	M.autocmds = M.autocmds or Autocmds:new(M.jit.autocmds)
	M.autocmds:toggle()

	M.usercmds = M.usercmds or Commands:new(M.jit.commands)
	M.usercmds:toggle()
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
