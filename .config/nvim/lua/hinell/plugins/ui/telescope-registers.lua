-- File........: telescope-registers.lua
-- Summary.....: telescope plugin
-- Created-at..: April 04, 2025
-- Authors.....: Alex A. Davronov <al.neodim@gmail.com> (2025-)
-- Repository..: N/A
-- Description.:  This plugin is modeled after Telescope registers that allows listing
-- & inserting registers into current buffer;
-- the main differences are: registers listings are configurable
-- TODO: [April 04, 2025] Make a PR to the upstream telescope repo
-- Usage.......: source in init.lua

--- @class telescope.registers.ConfInstance
--- @field extra boolean? add extra registers to the list ("",-,:,.,%,=,#)
--- @field numbered boolean? add numbered registers to the list

local M = {}

--- @param opts telescope.registers.ConfInstance
M.find = function(opts)
	local actions = require "telescope.actions"
	local finders = require "telescope.finders"
	local make_entry = require "telescope.make_entry"
	local pickers = require "telescope.pickers"
	local state = require "telescope.state"
	local utils = require "telescope.utils"

	local conf = require("telescope.config").values

	opts = opts or {}

	local registers_table = { "/", "*", "+" }

	if opts.extra then
		for i, reg in ipairs({ '""', '-', ':', '.', '"%', '=', '#'}) do
			table.insert(registers_table, reg)
		end
	end

	if opts.numbered then
		-- numbered
		for i = 0, 9 do
			table.insert(registers_table, tostring(i))
		end
	end

	-- alphabetical
	for i = 65, 90 do
		table.insert(registers_table, string.char(i))
	end

	M.registers_table = registers_table
	M.picker = pickers
	.new(opts, {
		prompt_title = "Registers",
		finder = finders.new_table {
			results = M.registers_table,
			entry_maker = opts.entry_maker or make_entry.gen_from_registers(opts),
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(_, map)
			actions.select_default:replace(actions.paste_register)
			map({ "i", "n" }, "<C-e>", actions.edit_register)
			return true
		end,
	}):find()
end

return M
