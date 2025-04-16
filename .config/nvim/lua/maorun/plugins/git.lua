return {
    {
        'tpope/vim-fugitive',
        event = 'VimEnter',
        init = function()
            local fugitiveAuGroup = vim.api.nvim_create_augroup('user_fugitive', {})
            vim.api.nvim_create_autocmd('BufReadPost', {
                group = fugitiveAuGroup,
                pattern = 'fugitive://*',
                command = 'set bufhidden=delete',
            })

            Maorun = Maorun or {}
            Maorun.git = {}
            function Maorun.git.resetToOrigin()
                vim.cmd(':execute ":G reset --hard origin/" . FugitiveHead()')
            end

            function Maorun.git.log()
                -- :GlLog --invert-grep --grep Automated --grep Phoenix
                vim.cmd [[
        :Flogsplit -all -date=short
        :execute "/HEAD -> " . FugitiveHead()
        :nohlsearch
    ]]
            end

            function Maorun.git.amend()
                vim.cmd [[
        :G add -A
        :G commit --amend --no-edit
    ]]
            end

            function Maorun.git.newBranch()
                -- prompt for branch name
                local branch = vim.fn.input('New branch name: ')
                if branch == '' then
                    return
                end
                vim.cmd(':G fetch --prune')
                -- create branch
                vim.cmd(string.format(':G branch %s origin/master', branch))
                vim.cmd(string.format(':G checkout %s', branch))
            end

            function Maorun.git.amendPush()
                Maorun.git.amend()
                Maorun.git.pushForce()
            end

            function Maorun.git.push()
                vim.cmd [[
        :execute ":G push origin " . FugitiveHead()
        :execute ":G branch --set-upstream-to=origin/" . FugitiveHead() . " " . FugitiveHead()
    ]]
            end

            function Maorun.git.pushForce()
                vim.cmd [[
        :execute ":G push --force origin " . FugitiveHead()
    ]]
            end
        end,
    },
    {
        'rbong/vim-flog', -- Git-Tree
        cmd = 'Flogsplit',
    },
    {
        -- enabled = false, -- startup-time-consuming
        'lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/which-key.nvim',
        },
        init = function()
            require('gitsigns').setup {
                current_line_blame = true,
            }
        end
    },
    {
        'sindrets/diffview.nvim',
    },
}
