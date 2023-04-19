local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
    error('This plugins requires nvim-telescope/telescope.nvim')
end

local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require "telescope.finders"
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local picker_opt = {
}

local displayer = entry_display.create({
    separator = " ",
    items = {
        { width = 80 },
        { remaining = true },
    },
})
local make_display = function(entry)
    return displayer({
        entry.value.item,
    })
end

timePicker = function(opts)
    local t = require 'time'
    local items = {
        {
            item = 'TimeStart()',
            func = t.TimeStart,
        },
        {
            item = 'TimeStop()',
            func = t.TimeStop,
        },
        {
            item = 'TimePause()',
            func = t.TimePause,
        },
        {
            item = 'TimeResume()',
            func = t.TimeResume,
        },
    }
    opts = vim.tbl_deep_extend("force", picker_opt, opts or {})
    pickers.new(opts, {
        prompt_title = 'Select a action',
        results_title = 'TimeActions',
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,

                    -- this is what we can fzf
                    ordinal = entry['item'],
                }
            end
        },
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                entry.value.func()

                actions.close(propt_bufnr)
            end)
            return true
        end,
        sorter = conf.generic_sorter(opts)
    }):find()
end

return telescope.register_extension({
    setup = function(ext_config, config)
        conf = vim.tbl_extend("force", conf, ext_config or {})
    end,
    exports = {
        time = timePicker
    },
})
