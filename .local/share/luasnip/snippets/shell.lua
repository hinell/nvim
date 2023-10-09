-- Shell snippets: sh, bash, zsh ...
M = {}

local ls = require("luasnip").add_snippet
-- table.insert(M, s({
-- 		trig = "zsh_test_trig",
-- 		filetype = "zsh" },
-- 		t("this is a shell snippet")
-- ))

M.log = function()
	print(("%s: lua shell snippets loaded"):format(debug.getinfo(1).source))
end

return M
