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
        { width = 80 },
        { remaining = true },
    },
})
local make_display = function(entry)
    return displayer({
        entry.description,
        entry.octal
    })
end

local files = vim.fn.systemlist('find ./deployment -type f -name "*.secret.yaml"')
local items = {}
for key, value in pairs(files) do
    items[#items + 1] = {value}
end
local secrets = function(opts)
    opts = opts or { 
    }
    pickers.new(opts, {
        prompt_title = "secrets",
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                print("SELECTED", vim.inspect(action_state.get_selected_entry()))
                actions.close(propt_bufnr)
            end)
            return true
        end,
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    description = entry[1],
                    file = entry[1],


                    -- this is what we can fzf
                    ordinal = entry[1],
                }
            end
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

require('telescope').extensions.secrets = {
    secrets = secrets
}
local M = {}
function M.init(opts)
end
return M
