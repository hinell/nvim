FUCKYOU
https://github.com/doxnit/cmp-luasnip-choice

VSCode like experience. Arrow keys are used to navigate across snippets. Support for choices tabstops (e.g. `${1|foo,bar,baz|}`)

Please install:
* [cmp-luasnip-choice](https://github.com/doxnit/cmp-luasnip-choice)


<details>
<summary>Show config</summary>

```lua
local ok, cmp = pcall(require, "cmp")
if not ok then
	error("cmp module is not found")
	return
end
cmp.setup { 
	mapping = {
	
		["<C-b>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.mapping.scroll_docs(-4)
			end
		end, { "i", "s" }),
		["<C-f>"] = cmp.mapping(function()
			if cmp.visible() then
			cmp.cmp.mapping.scroll_docs(4)
			end
		end, { "i", "s" }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-c>"]     = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<ESC>"]     = cmp.mapping(function(fallback)
			cmp.mapping.abort()
			luasnip.unlink_current()
			fallback()
		end),
		["<Up>"] = cmp.mapping(function(fallback) 
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
				if cmp.visible() then
					-- Instead of inserting, just focus a visual dropdown item
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					return
				end
			end
			if cmp.visible() then
				-- Instead of inserting, just focus a visual dropdown item
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			else
				fallback()
			end	
		end, { "i", "s", "c" }),
		["<Down>"] = cmp.mapping(function(fallback) 
			if luasnip.choice_active() then
				luasnip.change_choice(1)
				if cmp.visible() then
					-- Instead of inserting, just select a visual dropdown item
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					return
				end
			end
			if cmp.visible() then
				-- Instead of inserting, just select a visual dropdown item
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			else
				fallback()
			end
		end, { "i", "s", "c" }),
		["<CR>"] = -- cmp.mapping.confirm({ select = false }),
		cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.jump(1)
			elseif luasnip.expandable() then
				luasnip.expand()
			end
			
			if cmp.visible() then
				cmp.mapping.confirm({ select = true })
			else
				fallback()
			end
		end, { "i", "s" }),
		["<TAB>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable() then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			-- elseif luasnip.expandable() then
			-- 	luasnip.expand()
			elseif cmp.visible() then
				cmp.select_prev_item()
			else
			fallback()
			end
		end, { "i", "s" })
	}
}
````

</details>
