--- @module snippets
--- Snipets config
local M = {}

-- NOTE: [March 27, 2025] There is a way to parse snippets by using nvim's PEG
-- grammars, see neovim/runtime/lua/vim/lsp/_snippet_grammar.lua
-- E.g. require("vim.lsp._snippet_grammar")

M.ls = {}
M.ls.config = function(self)
	local luasnip   = require("luasnip")
	local util      = require("luasnip.util.util")
	local node_util = require("luasnip.nodes.util")

	-- luasnip.log.set_loglevel("debug")
	luasnip.setup({
		-- This interferes with nvim-cmp completion!
		-- See related pr: https://github.com/L3MON4D3/LuaSnip/issues/1029
		-- store_selection_keys = "<C-Space>",

		-- NOTE: Doesn't work well!
		-- Imitate VS Code behavior for nested placeholders
		-- See for more info:
		-- https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs#imitate-vscodes-behaviour-for-nested-placeholders
		parser_nested_assembler = function(_, snippetNode)
			local select = function(snip, no_move, dry_run)
				if dry_run then
					return
				end
				snip:focus()
				-- make sure the inner nodes will all shift to one side when the
				-- entire text is replaced.
				snip:subtree_set_rgrav(true)
				-- fix own extmark-gravities, subtree_set_rgrav affects them as well.
				snip.mark:set_rgravs(false, true)

				-- SELECT all text inside the snippet.
				if not no_move then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
					node_util.select_node(snip)
				end
			end

			local original_extmarks_valid = snippetNode.extmarks_valid
			function snippetNode:extmarks_valid()
				-- the contents of this snippetNode are supposed to be deleted, and
				-- we don't want the snippet to be considered invalid because of
				-- that -> always return true.
				return true
			end

			function snippetNode:init_dry_run_active(dry_run)
				if dry_run and dry_run.active[self] == nil then
					dry_run.active[self] = self.active
				end
			end

			function snippetNode:is_active(dry_run)
				return (not dry_run and self.active) or (dry_run and dry_run.active[self])
			end

			function snippetNode:jump_into(dir, no_move, dry_run)
				self:init_dry_run_active(dry_run)
				if self:is_active(dry_run) then
					-- inside snippet, but not selected.
					if dir == 1 then
						self:input_leave(no_move, dry_run)
						return self.next:jump_into(dir, no_move, dry_run)
					else
						select(self, no_move, dry_run)
						return self
					end
				else
					-- jumping in from outside snippet.
					self:input_enter(no_move, dry_run)
					if dir == 1 then
						select(self, no_move, dry_run)
						return self
					else
						return self.inner_last:jump_into(dir, no_move, dry_run)
					end
				end
			end

			-- this is called only if the snippet is currently selected.
			function snippetNode:jump_from(dir, no_move, dry_run)
				if dir == 1 then
					if original_extmarks_valid(snippetNode) then
						return self.inner_first:jump_into(dir, no_move, dry_run)
					else
						return self.next:jump_into(dir, no_move, dry_run)
					end
				else
					self:input_leave(no_move, dry_run)
					return self.prev:jump_into(dir, no_move, dry_run)
				end
			end

			return snippetNode
		end

	})

	require("luasnip.loaders.from_vscode").lazy_load({
		paths = {
			"~/.config/Code/User/snippets/"
		}
	})


	require("luasnip.loaders.from_lua").lazy_load({
		paths = {
			"~/.local/share/luasnip/snippets/"
		}
	})

	local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
	if legendaryIsOk then


		local funcs = {
			{ description = "Snippets: luasnip: open log", luasnip.log.open  }
		}

		legendary.funcs(funcs)
	end


end

M.init = function(self, packer)
	local use = packer.use

	-- Autocompletion/snippets
	use({
		  "hinell/LuaSnip",
		branch = "store_selection_for_v2",
		build   = "make install_jsregexp",
		config = M.ls.config,
	})
	-- M.ls:config()

	use({
		"benfowler/telescope-luasnip.nvim",
		lazy = true,
		-- module = "telescope._extensions.luasnip",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"hinell/LuaSnip"
		},
		init = function()

			-- Load this plugin only on request
			local legendaryIsOk, legendary = assert(pcall(require, "legendary"))
			if legendaryIsOk then
				local funcs = {
					{
						description = "Editor: completion: lua snippets (luasnips)"	, function()
							require("telescope").load_extension("luasnip");
							require("telescope").extensions.luasnip.luasnip()
							-- "<CMD>Telescope luasnip<CR>"
						end
					}
				}
				legendary.funcs(funcs)
			end
		end
	})

end

return M
