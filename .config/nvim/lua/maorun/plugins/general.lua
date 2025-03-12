return {
    {
        'folke/which-key.nvim',
        dependencies = { 'echasnovski/mini.nvim' },
        init = function()
            require('which-key').setup {}
        end
    },
    'nvim-lua/plenary.nvim',
    'tpope/vim-sleuth',                -- adjust 'shiftwidth' and 'expandtab'
    'tpope/vim-commentary',            -- gcc
    'tpope/vim-surround',              -- add/delete/change surround
    'tpope/vim-repeat',                -- repeat all plugins with .
    'vim-scripts/ReplaceWithRegister', -- replace with register - gr

    -- multi-select
    --  , 'mg979/vim-visual-multi', {'branch': 'master'}
    -- TODO: LEARN IT

    -- aa - around argument
    {
        'echasnovski/mini.ai',
        init = function()
            require('mini.ai').setup({
                mappings = {
                    goto_right = ']]',
                    goto_left = '[['
                }
            })
        end
    },
    {
        'nvim-tree/nvim-web-devicons',
        init = function()
            require 'nvim-web-devicons'.setup {
                color_icons = true,
                default = true
            }
        end
    },
    {
        enabled = false,
        'gelguy/wilder.nvim',
        init = function()
            vim.api.nvim_create_autocmd('CmdlineEnter', {
                group = vim.api.nvim_create_augroup('Wilder', {}),
                once = true,
                pattern = '*',
                callback = function()
                    local wilder = require('wilder')
                    wilder.setup({ modes = { ':', '/', '?' } })
                    wilder.set_option('pipeline', {
                        wilder.branch(
                            wilder.cmdline_pipeline({
                                language = 'python',
                                fuzzy = 2,
                            }),
                            wilder.python_search_pipeline({
                                pattern = wilder.python_fuzzy_pattern({
                                    start_at_boundary = 0
                                }),
                                sorter = wilder.python_difflib_sorter(),
                                engine = 're',
                            })
                        )
                    })
                    wilder.set_option('renderer', wilder.popupmenu_renderer({
                        highlighter = wilder.basic_highlighter(),
                        separator = ' · ',
                        left = { ' ', wilder.wildmenu_spinner(), ' ' },
                        right = { ' ', wilder.wildmenu_index() },
                    }))
                end,
            })
        end
    },
    -- Training
    --  , 'tjdevries/train.nvim'
    {
        'ThePrimeagen/vim-be-good',
        cmd = 'VimBeGood'
    },
    {
        'smoka7/hop.nvim',
        init = function()
            local hop = require 'hop'
            hop.setup {}
            vim.keymap.set('', 'S', function()
                hop.hint_char2({ multi_windows = true })
            end, { remap = true })
            vim.keymap.set('', 's', function()
                hop.hint_char2({ multi_windows = true })
            end, { remap = true })
        end
    },
    {
        'stevearc/quicker.nvim',
        event = 'FileType qf',
        opts = {},
    }
}
