local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')
require('telescope').setup({
    defaults = {
        file_ignore_patterns = {'node_modules', '__snapshots__', 'package%-lock%.json', 'composer%.lock'},
        mappings = {
            i = {
                ['<C-i>'] = actions.results_scrolling_up,
                ['<C-f>'] = actions.results_scrolling_down,
                ['<C-o>'] = action_layout.toggle_preview,
                ['<PageUp>'] = false,
                ['<PageDown>'] = false,
            },
        },
    },
    extensions = {
        gkeep = {
            find_method = 'all_text',
            link_method = 'title',
        },
    },
})
-- Load the extension
require('telescope').load_extension('gkeep')
vim.api.nvim_set_keymap('n', '<leader>tg', ':GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>', {noremap = true})

vim.api.nvim_set_keymap('n', '<leader>gsl', ':Telescope git_stash<cr>', {noremap = true})

require('telescope').load_extension('gh')
    -- // pull_request
    -- c-f browse modified files
    -- c-a approve
    -- c-e view details or diff
    -- c-r merge
    -- <cr> checkout
vim.api.nvim_set_keymap('n', '<leader>ghp', ':lua require('telescope').extensions.gh.pull_request()<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ghg', ':lua require('telescope').extensions.gh.gist()<cr>', {noremap = true})
