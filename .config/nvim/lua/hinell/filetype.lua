-- This file assumed to configure file types's specific nvim options like filetype, formatprg etc.
-- This is advised way to configure new filetypes that aren't configured
-- ftdetect or ftplugin
-- TODO: Move to after directory
vim.filetype.add({
	extension = {
		 ["code-snippets"] = function(path, bufnr)
			vim.opt_local.binary = false
			-- vim.opt_local.filetype = "json"
			-- vim.opt_local.formatprg = "jq ."
			vim.opt_local.formatprg = "clang-format --assume-filename=.json"
			return "json"
		end
		,["json"] = function(path, bufnr)
			-- vim.opt_local.formatprg = "jq ."
			vim.opt_local.formatprg = "clang-format --assume-filename=.json"
			return "json"
		end

		-- Buggy!
		-- ,["zsh"] = "sh"
		, ["js"] = function(path, bufnr)
			vim.opt_local.formatprg = "clang-format --assume-filename=.js"
			vim.opt_local.makeprg   = "npm run build"
			return "javascript"
		end
		, ["jsm"] = function(path, bufnr)
			vim.opt_local.formatprg = "clang-format --assume-filename=.js"
			vim.opt_local.makeprg   = "npm run build"
			return "javascript"
		end

		, ["jsx"] = function(path, bufnr)
			vim.opt_local.formatprg = "clang-format --assume-filename=.js"
			vim.opt_local.makeprg   = "npm run build"
			return "javascript.jsx"
		end

		, ["ts"] = function(path, bufnr)
			vim.opt_local.formatprg = "clang-format --assume-filename=.ts"
			vim.opt_local.makeprg   = "npm run build"
			return "typescript"
		end

		, ["tsx"] = function(path, bufnr)
			vim.opt_local.formatprg = "clang-format --assume-filename=.ts"
			vim.opt_local.makeprg   = "npm run build"
			return "typescript.tsx"
		end
	}
	, filename = {
		-- [".zshrc"] = "sh"
	}
	, pattern = {
	}
})

return "loaded"
