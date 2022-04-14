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
        { width = 40 },
        { remaining = true },
    },
})
local make_display = function(entry)
    return displayer({
        entry.description,
        entry.octal
    })
end

local colors = function(opts)
    opts = opts or { 
    }
    pickers.new(opts, {
        prompt_title = "color",
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                print("SELECTED", vim.inspect(action_state.get_selected_entry()))
                actions.close(propt_bufnr)
            end)
            return true
        end,
        finder = finders.new_table {
            results = {
                { "red", "#ff0000" },
                { "green", "#00ff00" },
                { "blue", "#0000ff" },
            },
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    description = entry[1],
                    octal = entry[2],

                    -- this is what we can fzf
                    ordinal = entry[1] .. " " .. entry[2],
                }
            end
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

require('telescope').extensions.colors = {
    colors = colors
}
local M = {}
function M.init(opts)
end
return M
