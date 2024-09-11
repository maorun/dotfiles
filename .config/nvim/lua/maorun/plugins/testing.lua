return {
    {
        'vim-test/vim-test',
        event = 'VimEnter',
        keys = {
            { '<leader>vtn', '<cmd>TestNearest<cr>', desc = 'runs the test nearest to the cursor', noremap = true },
            { '<leader>vts', '<cmd>TestSuite<cr>',   desc = 'runs the whole test suite',          noremap = true },
            { '<leader>vtf', '<cmd>TestFile<cr>',    desc = 'runs the whole test file',           noremap = true },
        },
    } }
