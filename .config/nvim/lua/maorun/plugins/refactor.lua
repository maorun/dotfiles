return {
    {
        'ThePrimeagen/refactoring.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' }
        },
        init = function()
            require('telescope').load_extension('refactoring')

            require('refactoring').setup({
                print_var_statements = {
                    typescriptreact = {
                        'console.dir({ where: "%s", var: %s}, { depth: 6 });',
                    },
                    typescript = {
                        'console.dir({ where: "%s", var: %s}, { depth: 6 });',
                    },
                }
            })
        end,
        keys = {
            { '<leader>dP',  ":lua require('refactoring').debug.printf({below = false})<CR>",      desc = 'add print-statement' },
            { '<leader>dc',  ":lua require('refactoring').debug.cleanup({})<CR>",                  desc = 'delete debugs' },
            { '<leader>dp',  ":lua require('refactoring').debug.printf({below = true})<CR>",       desc = 'add print-statement' },
            { '<leader>r',   group = 'Refactor' },
            { '<leader>rd',  group = 'debugs' },
            { '<leader>rdP', ":lua require('refactoring').debug.printf({below = false})<CR>",      desc = 'add print-statement' },
            { '<leader>rdc', ":lua require('refactoring').debug.cleanup({})<CR>",                  desc = 'delete debugs' },
            { '<leader>rdp', ":lua require('refactoring').debug.printf({below = true})<CR>",       desc = 'add print-statement' },
            { '<leader>rdv', ":lua require('refactoring').debug.print_var({ normal = true })<CR>", desc = 'print variable', },

            { '<leader>rr',  ":lua require('telescope').extensions.refactoring.refactors()<cr>",   desc = 'refactor-telescope', mode = { 'x', 'n' }, },
            -- {
            --     mode = { 'v' },
            --     { '<leader>r',   group = 'Refactor' },
            --     { '<leader>rd',  group = 'debugs' },
            --     { '<leader>rdv', ":lua require('refactoring').debug.print_var({})<CR>", desc = 'print visual text' },
            -- },

        },
    },
}
