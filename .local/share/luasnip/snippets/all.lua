local ls      = require("luasnip")
local s       = ls.snippet
local sn      = ls.snippet_node
local isn     = ls.indent_snippet_node
local t       = ls.text_node
local i       = ls.insert_node
local f       = ls.function_node
local c       = ls.choice_node
local d       = ls.dynamic_node
local r       = ls.restore_node
local events  = require("luasnip.util.events")
local ai      = require("luasnip.nodes.absolute_indexer")
local extras  = require("luasnip.extras")
local l       = extras.lambda
local rep     = extras.rep
local p       = extras.partial
local m       = extras.match
local n       = extras.nonempty
local dl      = extras.dynamic_lambda
local fmt     = require("luasnip.extras.fmt").fmt
local fmta    = require("luasnip.extras.fmt").fmta
local conds   = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types   = require("luasnip.util.types")
local parse   = require("luasnip.util.parser").parse_snippet
local ms      = ls.multi_snippet
local k       = require("luasnip.nodes.key_indexer").new_key

local packagePath = package.path
local HOME		  = vim.fn.getenv("HOME")
package.path = ("%s;%s;%s"):format(
	package.path,
	HOME .. "/.local/share/luasnip/?.lua",
	HOME .. "/.local/share/luasnip/?/init.lua"
)

local snippets = require("snippets")

package.path = packagePath


local M = {}

CMNT = function(_, parent)
	return parent.snippet.env.LINE_COMMENT .. " "
end

NL = t({ "", "" })

table.insert(
	M,
	s(
		"trigger",
		c(1, {
			sn(1, { f(CMNT), t({ "After jumping once, cursor is here -> " }), i(1, "is value selected?") }),
			sn(2, { f(CMNT), t({ "After jumping forward once, cursor is here -> " }), i(1, "value") }),
			sn(3, {
				f(CMNT), t({  "After expanding, the cursor is here ->["}), rep(1),  t( "]<- duplicate this text" ), NL,
				f(CMNT), t({  "After choosing again the snippet starts at -> "}), i(1, "default value!"), NL,
				f(CMNT), t({  "After filling out, this is a copy -> "}), rep(1), i(0)
			})
		})
	)
)

-- M = vim.tbl_extend("force", M, require("./shell.lua"))
return M
