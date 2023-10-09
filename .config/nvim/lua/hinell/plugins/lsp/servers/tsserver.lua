--- @module tsserver-config
-- tsserver LSP config
local M = {}

M.init = function(self, cfg)
	local lspconfigUtil = require("lspconfig.util")

	M.config = {
		-- root_dir =  lspconfigUtil.root_pattern( "tsconfig.json", "jsconfig.json", "package.json", ".git" ),
		-- root_dir =  function()
		-- 	local root_dir = lspconfigUtil.root_pattern( "tsconfig.json" )()
		-- 	print(("%s: root dir is called %s"):format(debug.getinfo(1).source, root_dir or "no path?"))
		-- 	return root_dir
		-- end,
		-- root_dir = lspconfigUtil.find_git_ancestor,
		init_options = {
			-- preferences = {},
			tsserver = {
				--
				-- The path to the directory where the `tsserver` log files will be created.
				-- If not provided, the log files will be created within the workspace, inside the `.log` directory.
				-- If no workspace root is provided when initializating the server and no custom path is specified then
				-- the logs will not be created.
				-- @default undefined
				-- /
				logDirectory = "/tmp/tsserver/",
				--
				-- Verbosity of the information logged into the `tsserver` log files.
				-- Log levels from least to most amount of details: `'terse'`, `'normal'`, `'requestTime`', `'verbose'`.
				-- Enabling particular level also enables all lower levels.
				-- @default 'off'
				-- /
				logVerbosity = "verbose", -- 'off' | 'terse' | 'normal' | 'requestTime' | 'verbose';
				--
				-- The path to the `tsserver.js` file or the typescript lib directory. For example: `/Users/me/typescript/lib/tsserver.js`.
				-- path = "";
				-- The verbosity of logging of the tsserver communication.
				-- Delivered through the LSP messages and not related to file logging.
				-- @default 'off'
				-- /
				trace = "messages", -- 'off' | 'messages' | 'verbose';
				--
				-- Whether a dedicated server is launched to more quickly handle syntax related operations, such as computing diagnostics or code folding.
				-- Allowed values:
				--  - auto: Spawn both a full server and a lighter weight server dedicated to syntax operations. The syntax server is used to speed up syntax operations and provide IntelliSense while projects are loading.
				--  - never: Don't use a dedicated syntax server. Use a single server to handle all IntelliSense operations.
				-- @default 'auto'
				-- /
				useSyntaxServer = "auto"
			}
		}
	}
	return vim.tbl_deep_extend("keep", cfg, M.config)
end

return M
