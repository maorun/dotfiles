local actions = require('telescope.actions')
local utils = require 'telescope.utils'
local action_state = require 'telescope.actions.state'
local transform_mod = require('telescope.actions.mt').transform_mod

local M = {}
M.actions = transform_mod({
    git_delete_stash = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        local _, ret, stderr = utils.get_os_command_output { 'git', 'stash', 'drop', selection.value }
        if ret == 0 then
            utils.notify('M.actions.git_delete_stash', {
                msg = string.format('Deleted stash: %s', selection.value),
                level = 'INFO',
            })
        end

        require 'telescope.builtin'.git_stash()
    end,
    git_delete_branch = function(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local action_name = 'actions.git_delete_branch'
        picker:delete_selection(function(selection)
            local branch = selection.value
            print('Deleting branch ' .. branch)
            local _, ret, stderr = utils.get_os_command_output({ 'git', 'branch', '-D', branch },
                picker.cwd)
            if ret == 0 then
                utils.notify(action_name, {
                    msg = string.format('Deleted branch: %s', branch),
                    level = 'INFO',
                })
            else
                utils.notify(action_name, {
                    msg = string.format("Error when deleting branch: %s. Git returned: '%s'", branch,
                        table.concat(stderr, ' ')),
                    level = 'ERROR',
                })
            end
            return ret == 0
        end)
    end,
    showGitBranches = function(prompt_bufnr)
        return require 'telescope.builtin'.git_branches({ pattern = 'refs/heads' })
    end,
})
return M
