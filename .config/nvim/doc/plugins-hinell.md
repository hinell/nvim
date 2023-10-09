### Profiler
This plugin exports jit profiler to get profiling info about all functions for the current VM. 
Enable:
```
require("hinell.profiler").nvim_commands:toggle() -- or enable()
```

Use:
```
JITProfilerStart FILE_NAME - start & write profile into CWD/FILE_NAME 
JITProfilerStop - finish profiling, save to the said file
```

The name for the output file may also be supplied via ENV variable: ```vim.env.PROFILER_FILE_NAME```

----
December 06, 2023
