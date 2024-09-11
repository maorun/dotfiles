return {
    {
        'rgroli/other.nvim',
        event = 'VimEnter',
        init = function()
            require('other-nvim').setup({
                rememberBuffers = false,
                mappings = {
                    {
                        pattern = '(.*/)([^%.]+)(%..+)%.tsx$',
                        target = {
                            { target = '%1%2.tsx',           context = 'component' },
                            { target = '%1%2.component.tsx', context = 'component' },
                            { target = '%1%2.test.tsx',      context = 'test' },
                            { target = '%1%2.stories.tsx',   context = 'story' },
                            { target = '%1%2.mdx',           context = 'MDX' },
                        }
                    },
                    {
                        pattern = '(.*/)([^%.]+)%.mdx$',
                        target = {
                            { target = '%1%2.tsx',           context = 'component' },
                            { target = '%1%2.component.tsx', context = 'component' },
                            { target = '%1%2.test.tsx',      context = 'test' },
                            { target = '%1%2.stories.tsx',   context = 'story' },
                            { target = '%1%2.mdx',           context = 'MDX' },
                        }
                    },
                    {
                        pattern = '(.*/)([^%.]+)%.tsx$',
                        target = {
                            { target = '%1%2.tsx',           context = 'component' },
                            { target = '%1%2.component.tsx', context = 'component' },
                            { target = '%1%2.test.tsx',      context = 'test' },
                            { target = '%1%2.stories.tsx',   context = 'story' },
                            { target = '%1%2.mdx',           context = 'MDX' },
                        }
                    }
                },
            })
        end,
        keys = {
            { '<leader>tn',  group = ':Other' },
            { '<leader>tnn', '<cmd>:Other<cr>',       desc = ':Other',       remap = false },
            { '<leader>tns', '<cmd>:OtherSplit<cr>',  desc = ':OtherSplit',  remap = false },
            { '<leader>tnv', '<cmd>:OtherVSplit<cr>', desc = ':OtherVSplit', remap = false },
        }
    }
}
