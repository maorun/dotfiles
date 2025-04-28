return {
    {
        'tpope/vim-fugitive',
        event = 'VimEnter',
        config = function()
            local fugitiveAuGroup = vim.api.nvim_create_augroup('user_fugitive', {})
            vim.api.nvim_create_autocmd('BufReadPost', {
                group = fugitiveAuGroup,
                pattern = 'fugitive://*',
                command = 'set bufhidden=delete',
            })

        end,
    },
    {
        'rbong/vim-flog', -- Git-Tree
        cmd = 'Flogsplit',
        dependencies = {
            "tpope/vim-fugitive",
        },
    },
    {
        -- enabled = false, -- startup-time-consuming
        'lewis6991/gitsigns.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/which-key.nvim',
        },
        opts = {
            current_line_blame = true,
        },
    },
    {
        'sindrets/diffview.nvim',
    },
}
