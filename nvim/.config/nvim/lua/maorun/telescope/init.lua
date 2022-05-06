local actions = require('telescope.actions')
local builtin = require'telescope.builtin'
local action_layout = require('telescope.actions.layout')
local utils = require "telescope.utils"
local action_state = require "telescope.actions.state"

local transform_mod = require("telescope.actions.mt").transform_mod
local localActions = transform_mod({
    git_delete_branch = function(prompt_bufnr)
        local command = function(branch_name)
            return { "git", "branch", "-D", branch_name }
        end

        local cwd = action_state.get_current_picker(prompt_bufnr).cwd
        local selection = action_state.get_selected_entry()

        actions.close(prompt_bufnr)
        local _, ret, stderr = utils.get_os_command_output(command(selection.value), cwd)
        if ret == 0 then
            utils.notify('localActions.git_delete_branch', {
                msg = string.format("Deleted branch: %s", selection.value),
                level = "INFO",
            })
        else
            utils.notify('localActions.git_delete_branch', {
                msg = string.format("Error when deleting branch: %s. Git returned: '%s'", selection.value, table.concat(stderr, " ")),
                level = "ERROR",
            })
        end
    end,
    showGitBranches = function(prompt_bufnr)
        return require'telescope.builtin'.git_branches()
    end,
})


require('telescope').setup({
    defaults = {
        file_ignore_patterns = {'node_modules', '__snapshots__', 'package%-lock%.json', 'composer%.lock'},
        mappings = {
            i = {
                ['<C-i>'] = actions.results_scrolling_up,
                ['<C-f>'] = actions.results_scrolling_down,
                ['<C-O>'] = action_layout.toggle_preview,
                ['<PageUp>'] = false,
                ['<PageDown>'] = false,
                ['<Down>'] = false,
                ['<C-j>'] = actions.move_selection_next,
                ['<Up>'] = false,
                ['<C-k>'] = actions.move_selection_previous,
            },
        },
    },
    pickers = {
        buffers = {
            mappings ={
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
            },
        },
        git_branches = {
            mappings = {
                i = {
                    ['<c-d>'] = localActions.git_delete_branch + localActions.showGitBranches,
                }
            }
        }
    },
    extensions = {
        project = {
            base_dirs = {
                '~/repos',
            },
        },
        gkeep = {
            find_method = 'all_text',
            link_method = 'title',
        },
    },
})




-- Load the extension
require('telescope').load_extension('gkeep')

require('telescope').load_extension('coc')

require('telescope').load_extension('gh')
    -- // pull_request

    -- c-f browse modified files
    -- c-a approve
  -- c-e view details or diff
    -- c-r merge
    -- <cr> checkout

require('maorun.telescope.secrets').init()
require('maorun.telescope.k8s').init()

require("telescope").load_extension('harpoon')
require'telescope'.load_extension('project')
-- require'telescope'.load_extension('secrets')

require"octo".setup()

local wk = require("which-key")
wk.register({
    [ '<leader>' ] = { ":lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
    t = {
        name = "Telescope",
        o = { ':Octo actions<cr>', "Pull Requests", noremap = true },
        g = { ':GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>', "Google Keep", noremap = true },
        f = { ":lua require('telescope.builtin').find_files()<cr>", "Find files", noremap = true },
        r = { ":lua require('telescope.builtin').live_grep()<cr>", "Live Grep", noremap = true },
        k = { ":Telescope k8s<cr>", "Kubernetes", noremap = true },
        s = { ":lua require('maorun.telescope.secrets').secrets()<cr>", "Secrets", noremap = true },
        h = { ":Telescope harpoon marks<cr>", "Harpoon marks", noremap = true },
        p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "Project", noremap = true },
    },
    g = {
        name = "Git",
        s = {
            l = { ':Telescope git_stash<cr>', "Stash list", noremap = true },
        },
        g = { ":lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
        b = { ":lua require'telescope.builtin'.git_branches()<cr>", "Git branches", noremap = true },
        h = {
            name = "GitHub",
            p = {':lua require("telescope").extensions.gh.pull_request()<cr>', "Pull Request", noremap = true},
            g = {':lua require("telescope").extensions.gh.gist()<cr>', "Gist", noremap = true},
        },
    },
    b = {
        name = "Buffer",
        b = {':lua require("telescope.builtin").buffers()<cr>', "show Buffers", noremap = true },
        d = {':%bd|e#<cr>', "delete all buffers", noremap = true },
        n = { function()
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_command('edit ' .. vim.api.nvim_buf_get_number(buf))
            vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
            vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
            vim.api.nvim_buf_set_option(0, 'swapfile', false)
        end, "new buffer", noremap = true },
    },
}, { prefix = "<leader>" })

--
-- nnoremap <leader>of :Telescope colors<cr>

local M = {}
function M.init(opts)
end
return M
