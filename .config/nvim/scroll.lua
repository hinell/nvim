local ffi = require("ffi")
ffi.cdef[[
	cmdarg_T ca;
	static void nv_scroll_line(cmdarg_T *cap);
]]

ffi.C.ca.arg = true
ffi.C.nv_scroll_line(ffi.C.ca)

