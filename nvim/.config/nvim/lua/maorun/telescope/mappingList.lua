local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local displayer = entry_display.create({
    separator = " ",
    items = {
        { remaining = true },
    },
})
local make_display = function(entry)
    return displayer({
        entry.description,
    })
end

mappingList= function(opts)
    opts = opts or {
        title = '',
        list = {},
    }
    pickers.new(opts, {
        prompt_title = "Mappings for " .. opts.title,
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(propt_bufnr)
            end)
            return true
        end,
        finder = finders.new_table {
            results = opts.list,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    description = entry,
                    octal = entry,

                    -- this is what we can fzf
                    ordinal = entry
                }
            end
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

require('telescope').extensions.mappingList= {
    mappingList = mappingList
}
local M = {}
function M.init(opts)
end
function M.mappingList(opts)
    mappingList(opts)
end
return M
