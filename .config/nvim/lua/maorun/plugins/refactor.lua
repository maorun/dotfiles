return {
    {
        'ThePrimeagen/refactoring.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' }
        },
        enabled = false,
        init = function()
            require('telescope').load_extension('refactoring')

            require('refactoring').setup({
                print_var_statements = {
                    typescriptreact = {
                        'console.log("%s", %s);',
                    },
                    typescript = {
                        'console.dir({ where: "%s", var: %s}, { depth: 6 });',
                    },
                }
            })
        end,
    },
}
