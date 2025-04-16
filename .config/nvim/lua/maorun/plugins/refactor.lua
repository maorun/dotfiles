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
    },
}
