local   napi		= require("nvim-api")
local   feedkeys	= napi.feedkeys

local M	= {}
M.completion_abort = function(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	cmp.abort()
	luasnip.unlink_current()
	fallback()
end

M.cmp = {}
M.cmp.mapping = function(self, cmp, luasnip)

	if not cmp then error("Please, provide cmp instance!") end
	if not luasnip then error("Please, provide luasnip instance!") end

	local mapping = {}
	mapping["<C-b>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.scroll_docs(-4)
		else
			return fallback()
		end
	end, { "i", "s" })

	mapping["<C-f>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.scroll_docs(4)
		else
			return fallback()
		end
	end, { "i", "s" })

	mapping["<C-Space>"] = cmp.mapping({
		i = function(fallback)
			luasnip = require("luasnip")
			-- This if you remove this, then make
			-- sure that nvim-cmp doesn't replace luasnip choices
			if luasnip.choice_active() then
				if not cmp.complete({
					config = {
						sources = {
							{ name = "luasnip_choice" },
							{ name = "luasnip" }
						}
					}
				}) then
					cmp.abort()
					return fallback()
				end
				return
			end

			if not cmp.complete() then
				cmp.abort()
				luasnip.unlink_current()
				return fallback()
			end
		end,

		-- nvim-cmp maps v mode to x
		-- see nvim-cmp/lua/cmp/utils/api.lua
		x = function(fallback)

			local mode = vim.fn.mode()
			print(("%s: completion mode %s"):format(debug.getinfo(1).source, mode))
			luasnip = require("luasnip")
			-- TODO: [December 05, 2023] remove ^V if doesn't work!
			if mode:match("[vV]") and not luasnip.get_active_snip() then

				require("luasnip.util.util").store_selection()
				vim.cmd([[noautocmd normal gv]])
				vim.cmd([[noautocmd normal "_d]])
				vim.cmd("startinsert")

				vim.defer_fn(function()
					-- local ctrlSpace = vim.api.nvim_replace_termcodes("<C-Space>", true, false, true)
					-- vim.api.nvim_feedkeys(ctrlSpace, "nx!", false)
					if not cmp.complete() then
						cmp.abort()
						luasnip.unlink_current()
						return fallback()
					end
				end, 50)
			end
		end,

		s = function(fallback)
			-- TODO: [May 16, 2023] Fix selection to snipppet command
			error(("TODO: [May 16, 2023] implement s_CTRL-Space!"))

			local mode = vim.fn.mode()
			print(("%s: completion mode -> %s"):format(debug.getinfo(1).source, mode))
			luasnip = require("luasnip")
			if mode:match("[sS]") and not luasnip.get_active_snip() then
				require("luasnip.util.util").store_selection()
				vim.cmd([[noautocmd normal <C-g>]])
				-- vim.cmd([[noautocmd normal gv]])
				vim.cmd([[noautocmd normal "_d]])
				vim.cmd("startinsert!")

				vim.defer_fn(function()
					-- local ctrlSpace = vim.api.nvim_replace_termcodes("<C-Space>", true, false, true)
					-- vim.api.nvim_feedkeys(ctrlSpace, "nx!", false)
					if not cmp.complete() then
						cmp.abort()
						luasnip.unlink_current()
						return fallback()
					end
				end, 50)
				return
			end

			if luasnip.jumpable() then
				-- If we have recursive snippet,
				-- then we can expand wrapped names
				-- print("Line [ ", vim.fn.line("v"), vim.fn.line("'>"), " ]")
				-- print("Col  [ ", vim.fn.col("v") , vim.fn.col("'>") , " ]")
				local l, c = vim.fn.line("v"), vim.fn.col("'>")
				feedkeys("<ESC>", "nx")
				vim.fn.cursor(l, c)
				vim.cmd("startinsert!")
			else
				-- If this is nto a recursive snippet, then just copy selection
				-- and use it inside next snippet
				require("luasnip.util.util").store_selection()
				feedkeys("d", "nx", true)
				vim.cmd("startinsert!")
			end

			local cmpResult = cmp.complete()
			vim.notify("cmpResult", vim.log.levels.INFO)
			if not cmpResult then
				cmp.abort()
				luasnip.unlink_current()
				return fallback()
			end
		end
	})

-- 	C>
-- 	-- cmp.mapping.complete({ })(fallback)
-- 	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gv"_s', true, false, true), "xn", true)
--
-- 	-- feedkeys('gv"_s', "nx!", true)
-- 	-- vim.cmd(":startinsert")
-- 	-- This nees to be posponed because of the 'store_selection' run by luasnip
-- 	local timer = vim.loop.new_timer()
-- 	-- Don't setup long timeouts, as it would pollute memory with fns
-- 	timer:start(50, 0, vim.schedule_wrap(function()
-- 		if not cmp.complete() then
-- 			cmp.abort()
-- 			luasnip.unlink_current()
--
-- 			timer:stop()
-- 			timer:close()
--
-- 			return fallback()
-- 		end
-- 	end))
--
-- end, { "x", "s", "v"  })
	-- ["<C-Space>"] = cmp.mapping(function(fallback)
	-- 	cmp.mapping.complete()(fallback)
	-- end, { "i" })
	-- ["<C-c>"]     = cmp.mapping.abort,
	mapping["<C-c>"]     = cmp.mapping(M.completion_abort, { "i", "s", "v", "x" })
	-- ["<Up>"] = SPECIFY HANLDER IN SPECIFIC SNIPPET ENGINE,
	-- ["<Down>"] = SPECIFY HANLDER IN SPECIFIC SNIPPET ENGINE,
	-- ["<CR>"] = SPECIFY HANLDER IN SPECIFIC SNIPPET ENGINE,
	-- ["<C-S-j>"] = cmp.mapping(function(fallback)

	-- ["<ESC>"] = cmp.mapping(M.completion_abort),
	-- ["<C-z>"] = cmp.mapping(M.completion_abort),
	mapping["<Up>"] = cmp.mapping(function(fallback)
		-- Uncomment this, you you don't detect active choice
		-- on CTRL+Space hanlder

		-- if luasnip.choice_active() then
		-- 	luasnip.change_choice(-1)
		-- 	if cmp.visible() then
		-- 		-- Instead of inserting, just focus a visual dropdown item
		-- 		cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
		-- 		return
		-- 	end
		-- end

		if cmp.visible() then
			print("cmp: up")
			-- if luasnip.choice_active() then
			-- 	return cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			-- end
			cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
		else
			fallback()
		end
	end, { "i", "s", "c" })

	mapping["<Down>"] = cmp.mapping(function(fallback)
		-- Uncomment this, you you don't detect active choice
		-- on CTRL+Space hanlder

		-- if luasnip.choice_active() then
		-- 	luasnip.change_choice(1)
		-- 	if cmp.visible() then
		-- 		-- Instead of inserting, just select a visual dropdown item
		-- 		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		-- 		return
		-- 	end
		-- end
		if cmp.visible() then
			-- if luasnip.choice_active() then
			-- 	cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			-- 	return
			-- end
			cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
		else
			fallback()
		end
	end, { "i", "s", "c" })

	mapping["<CR>"] = cmp.mapping(function(fallback)

		-- TODO: [May 23, 2023] Replace navigation across tabstops by <TAB>?
		-- See: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#safely-select-entries-with-cr
		-- if luasnip.choice_active() then
		-- 	-- TODO: [May 22, 2023] Fix <CR> hit on the nvim-cmp
		-- 	return luasnip.jump(1)
		-- 	-- cmp.confirm({
		-- 	-- 	select = true
		-- 	-- })
		--
		-- elseif luasnip.jumpable() and cursor.hasWordsBefore() then
		-- 	--NOTE: Until 'cfafe0a1ca8933f7b7968a287d39904156f2c57d'
		-- 	--commit this was buggy
		-- 	return luasnip.jump(1)
		-- 	-- return luasnip.expand_or_jump()
		-- 	-- return cmp.confirm({
		-- 	-- 	behavior = cmp.ConfirmBehavior.Replace
		-- 	-- })
		-- end

		if cmp.visible() then
			cmp.confirm({
				-- Select the first entry automatically
				select = true,
				behavior=cmp.ConfirmBehavior.Insert
			})
			cmp.close()
			return
		else
			fallback()
		end
	end, { "i", "s", "v" })

	mapping["<Tab>"] = cmp.mapping(function(fallback)
		-- print(("%s: snippet %s"):format(debug.getinfo(1).source, luasnip.jumpable(1)))
		local luasnip = require("luasnip")
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	-- -- See also $PLUGINS/lua/cmp/utils/keymap.lua
	end, { "i", "s", "c" });
	-- end, { "i", "x" , "s", "c" });

	mapping["<S-Tab>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		-- elseif luasnip.expandable() then
		-- 	luasnip.expand()
		-- elseif cmp.visible() then
		-- 	cmp.select_prev_item()
		else
			fallback()
		end
	end, { "i", "s", "c" });

	return mapping
end

-- See source
-- https://github.com/Shatur/neovim-config/blob/0c4ba0d7278eecb84c72b00c27b94f7470022329/plugin/cmp.lua#L58
-- UPD: Some icons were deleted in v3.0 of Nerd
M.completion_icons = {
	  Text          = { kind = "🗟", menu = "Text"        },
	  Method        = { kind = "", menu = "Method"      },
	  Function      = { kind = "󰊕", menu = "Function"    },
	  Constructor   = { kind = "", menu = "Constructor" },
	  Field         = { kind = "", menu = "Field"       },
	  Variable      = { kind = "", menu = "Variable"    },
	  Class         = { kind = "ﴯ", menu = "Class"       },
	  Interface     = { kind = "", menu = "Interface"   },
	  Module        = { kind = "", menu = "Module"      },
	  Property      = { kind = "", menu = "Property"    },
	  Unit          = { kind = "", menu = "Unit"        },
	  Value         = { kind = "", menu = "Value"       },
	  Enum          = { kind = "", menu = "Enum"        },
	  Keyword       = { kind = "", menu = "Keyword"     },
	  Snippet       = { kind = "󰘍", menu = "Snippet"     },
	  Color         = { kind = "󰏘", menu = "Color"       },
	  File          = { kind = "", menu = "File"        },
	  Reference     = { kind = "󰌷", menu = "Reference"   },
	  Folder        = { kind = "", menu = "Folder"      },
	  EnumMember    = { kind = "", menu = "Enum-member" },
	  Constant      = { kind = "", menu = "Constant"    },
	  Struct        = { kind = "פּ", menu = "Struct"      },
	  Event         = { kind = "", menu = "Event"       },
	  Operator      = { kind = "", menu = "Operator"    },
	  TypeParameter = { kind = "", menu = "Type-param"  },
	  GitHub        = { kind = "", menu = "GitHub"      }
}

M.config = function(self)
	local cmp	  = require("cmp")
	local luasnip = require("luasnip")
	local mapping = vim.tbl_extend("keep" , {}, M.cmp:mapping(cmp, luasnip))
		  vim.o.omnifunc     = "v:lua.require(\"cmp\").mapping.complete()"
		  vim.o.completefunc = "v:lua.require(\"cmp\").mapping.complete()"

	-- cmp config
	local config = {}
	config.completion = {}
	config.completion.autocomplete = false
	config.experimental = {}
	-- config.experimental.ghost_text = true
	config.snippet = {}
	-- Specifies which engine to use to expand an LSP snippet
	config.snippet.expand = function(args)
		-- vim.fn["vsnip#anonymous"](args.body)
		require("luasnip").lsp_expand(args.body)
		-- require("snippy").expand_snippet(args.body)
		-- vim.fn["UltiSnips#Anon"](args.body)
	end
	config.mapping = mapping

	local sources_1 = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		-- TODO: [November 16, 2023] finish for other languages
		-- This is very slow
		-- inspired by https://github.com/piersolenski/telescope-import.nvim
		-- { name = "rg", option = { pattern = [[^(?:(source|\.)\s+).*]], additional_arguments = "--max-depth 6" } },
		-- { name = "rg", option = { pattern = [[^(?:local\s+\w+)\s*=\s*require\s*\(?\s*\P{M}.*\P{M}\)?]], additional_arguments = "--max-depth 6" } },

		-- { name = "vsnip" },
		-- { name = "ultisnips" },
		-- { name = "snippy" },
	}


	local sources_2 = {}
	sources_2[#sources_2+1] = { name = "buffer" }
	-- sources_2[#sources_2+1] = { name = "buffer" }
	-- sources_2[#sources_2+1] = { name = "buffer-lines" }

	config.sources = cmp.config.sources(sources_1, sources_2)

	-- config.documentation.window.documentation = cmp.config.window.bordered()
	config.window = {}
	config.window.documentation = {}
	-- config.window.documentation.max_height = 40

	local cmpUnderComparatorIsOk, cmpUnderComparator = assert(pcall(require, "cmp-under-comparator"))
	cmp.config.compare.under = cmpUnderComparatorIsOk
		and cmpUnderComparator.under
		or function() return true end

	config.sorting = {
		 comparators = {
			 -- NOTE: The default cmp config may affect this
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.under,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order
		 }
	 }
	-- CMP fomratting
	 config.formatting = {
		fields = { "abbr", "menu", "kind" },
		format = function(entry, vim_item)
		  local key = entry.source.name == "git" and "GitHub" or vim_item.kind
		  local completion_type = M.completion_icons[key]
		  vim_item.kind = completion_type.kind
		  vim_item.menu = completion_type.menu
		  return vim_item
		end
	}

	cmp.setup(config) -- nvim-cmp.setup()
		-- Use buffer source for `/` and `?`i f you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			-- { name = "rg" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "buffer-lines" },
			{ name = "nvim_lsp_document_symbol" },
		},
	})
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
			{ name = "buffer" }
		}, {
		})
	})

end

M.legendary = {}
M.init = function(self, packer)
	local use = packer.use

	use({ "saadparwaiz1/cmp_luasnip"	})
	use({
		"L3MON4D3/cmp-luasnip-choice",
		config = function()
			require("cmp_luasnip_choice"):setup({
				auto_open = true
			})
	  end
	})

	use({ "hrsh7th/cmp-nvim-lsp"		})
	use({ "hrsh7th/cmp-buffer"			})
	use({ "hrsh7th/cmp-path"			})
	use({ "hrsh7th/cmp-cmdline"			})
	use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
	-- use({ "hrsh7th/vim-vsnip"			})
	-- use({ "hrsh7th/cmp-vsnip"			})

	use({ --hrsh7th/nvim-cmp
		"hrsh7th/nvim-cmp",
		dependencies = {
			 "hrsh7th/cmp-nvim-lsp"
			,"hrsh7th/cmp-buffer"
			,"hrsh7th/cmp-path"
			,"hrsh7th/cmp-cmdline"
			-- ,"hrsh7th/vim-vsnip"
			-- ,"hrsh7th/cmp-vsnip"
			,"saadparwaiz1/cmp_luasnip"
			,"lukas-reineke/cmp-under-comparator"
			,"lukas-reineke/cmp-rg"
			,"amarakon/nvim-cmp-buffer-lines"
			,"hrsh7th/cmp-nvim-lsp-signature-help"
			,"hrsh7th/cmp-nvim-lsp-document-symbol"
		},
		config = M.config
	})

    -- M:cmpConfig()
	-- Complete search
	use({ "lukas-reineke/cmp-rg" })
	use({ "lukas-reineke/cmp-under-comparator" })
	use({ "amarakon/nvim-cmp-buffer-lines" })

end

return M
