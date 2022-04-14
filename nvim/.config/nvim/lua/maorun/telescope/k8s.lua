local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local utils = require "telescope.utils"
  -- local output = utils.get_os_command_output(
  --   { "git", "for-each-ref", "--perl", "--format", format, opts.pattern },
  --   opts.cwd
  -- )

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

local k8s = function(opts)
    local cmd = "git branch --show-current | tr '[:upper:]' '[:lower:]' | tr -C \"[a-z0-9\\n]\" '-'"
    local namespace = vim.fn.trim('ac-steam-' .. vim.fn.system(cmd))
    local files = vim.fn.systemlist("kubectl get -n " .. namespace .. " pod -o name | sed 's/pod\\///g'")
    local items = {}
    for key, value in pairs(files) do
        items[#items + 1] = {value}
    end
    opts = opts or { 
    }
    pickers.new(opts, {
        prompt_title = "k8s",
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                local pod = action_state.get_selected_entry().pod
                local cmd = "kubectl exec -it " .. pod .. " -c php -n " .. namespace .. " -- /bin/sh"
                local logsCmd = "kubectl logs " .. pod .. " -c php -n " .. namespace .. " -f --since=5m"
                vim.fn.system("tmux new-window -n k8s -t 'ac-steam' ' " .. logsCmd .. "'")
                vim.fn.system("tmux split-window -t 'ac-steam:k8s' " .. cmd )

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
                    pod = entry[1],


                    -- this is what we can fzf
                    ordinal = entry[1],
                }
            end
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

require('telescope').extensions.k8s = {
    k8s = k8s
}
local M = {}
function M.init(opts)
end
return M
