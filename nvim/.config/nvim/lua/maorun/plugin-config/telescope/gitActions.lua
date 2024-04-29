local actions = require('telescope.actions')
local utils = require "telescope.utils"
local action_state = require "telescope.actions.state"
local transform_mod = require("telescope.actions.mt").transform_mod

local M = {}
M.actions = transform_mod({
    git_delete_stash = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        print(vim.inspect(selection))

        local _, ret, stderr = utils.get_os_command_output { "git", "stash", "drop", selection.value }
        if ret == 0 then
            utils.notify('M.actions.git_delete_stash', {
                msg = string.format("Deleted stash: %s", selection.value),
                level = "INFO",
            })
        end

        require'telescope.builtin'.git_stash()
    end,
    git_delete_branch = function(prompt_bufnr)
        local command = function(branch_name)
            return { "git", "branch", "-D", branch_name }
        end

        local cwd = action_state.get_current_picker(prompt_bufnr).cwd
        local selection = action_state.get_selected_entry()

        actions.close(prompt_bufnr)
        local _, ret, stderr = utils.get_os_command_output(command(selection.value), cwd)
        if ret == 0 then
            utils.notify('M.actions.git_delete_branch', {
                msg = string.format("Deleted branch: %s", selection.value),
                level = "INFO",
            })
        else
            utils.notify('M.actions.git_delete_branch', {
                msg = string.format("Error when deleting branch: %s. Git returned: '%s'", selection.value, table.concat(stderr, " ")),
                level = "ERROR",
            })
        end
    end,
    showGitBranches = function(prompt_bufnr)
        return require'telescope.builtin'.git_branches({pattern = 'refs/heads'})
    end,
})
return M

