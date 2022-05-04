local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

-- local action_set = require "telescope.actions.set"
-- local transform_mod = require("telescope.actions.mt").transform_mod
-- local my_cool_custom_action = transform_mod({
--     x = function (prompt_bufnr)
--         print("action")
--         action_set.shift_selection(prompt_bufnr, -1)
--     end,
-- })

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

                -- should be in picker mappings, but it doesn't work
                ["<C-D>"] = actions.delete_buffer + actions.move_to_top,
            },
        },
    },
    -- pickers = {
    --     buffers = {
    --         mappings = {
    --             i = {
    --             }
    --         }
    --     }
    -- },
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

require"octo".setup()

local wk = require("which-key")
wk.register({
    [ '<leader>' ] = { "<cmd>lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
    t = {
        name = "Telescope",
        o = { ':Octo actions<cr>', "Pull Requests", noremap = true },
        g = { ':GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>', "Google Keep", noremap = true },
        f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find files", noremap = true },
        r = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep", noremap = true },
        k = { "<cmd>Telescope k8s<cr>", "Kubernetes", noremap = true },
        s = { "<cmd>Telescope secrets<cr>", "Secrets", noremap = true },
        q = { "<cmd>Telescope quickJump<cr>", "quickJump", noremap = true },
        h = { "<cmd>Telescope harpoon marks<cr>", "Harpoon marks", noremap = true },
        p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "Project", noremap = true },
    },
    g = {
        name = "Git",
        s = {
            l = { ':Telescope git_stash<cr>', "Stash list", noremap = true },
        },
        g = { "<cmd>lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
        b = { "<cmd>lua require'telescope.builtin'.git_branches{}<cr>", "Git branches", noremap = true },
        h = {
            name = "GitHub",
            p = {':lua require("telescope").extensions.gh.pull_request()<cr>', "Pull Request", noremap = true},
            g = {':lua require("telescope").extensions.gh.gist()<cr>', "Gist", noremap = true},
        },
    },
    b = {
        name = "Buffer",
        b = {'<cmd>lua require("telescope.builtin.internal").buffers()<cr>', "show Buffers", noremap = true },
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
