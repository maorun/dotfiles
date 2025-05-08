return {
    {
        'cbochs/grapple.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons', lazy = true }
        },
        opts = {
            scope = 'packages',
            scopes = {
                {
                    name = 'packages',
                    desc = 'depending on packages',
                    fallback = 'git',
                    cache = {
                        event = { 'BufEnter', 'FocusGained' },
                        debounce = 1000, -- ms
                    },
                    resolver = function()
                        local packagefolder = vim.fs.find('packages/', {
                            upward = true,
                            stop = vim.loop.os_homedir(),
                        })
                        if #packagefolder == 0 then
                            return
                        end

                        local root = packagefolder[1]

                        local id = vim.api.nvim_buf_get_name(0):match('packages/([a-z]*)/')
                        if not id then
                            return
                        end
                        return id, root
                    end
                },
            },
        },
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = 'Grapple',
        keys = {
            { '<leader>m', '<cmd>Grapple toggle<cr>',          desc = 'Grapple toggle tag' },
            { '<leader>M', '<cmd>Grapple toggle_tags<cr>',     desc = 'Grapple open tags window' },
            { '<leader>1', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
            { '<leader>2', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
        },
    }
}
