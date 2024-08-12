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
                        '// %s \nconsole.dir(%s, { depth: 6 });',
                    },
                    typescript = {
                        '// %s \nconsole.dir(%s, { depth: 6 });',
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

            -- {
            --     mode = { 'v' },
            --     { '<leader>r',   group = 'Refactor' },
            --     { '<leader>rd',  group = 'debugs' },
            --     { '<leader>rdv', ":lua require('refactoring').debug.print_var({})<CR>", desc = 'print visual text' },
            -- },

            -- {
            --     mode = { "n", "x" },
            --     {
            --         "<leader>rr",
            --         function()
            --             require('telescope').extensions.refactoring.refactors()
            --         end,
            --         noremap = true
            --     },
            -- }
        },
    },
}
