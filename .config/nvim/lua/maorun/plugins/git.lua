return {
    {
        'tpope/vim-fugitive',
        event = 'VimEnter',
        keys = {
            { '<leader>g',   group = 'Git' },
            { '<leader>ga',  group = 'Amend' },
            { '<leader>gaa', ':lua Maorun.git.amend()<cr>',                                 desc = 'Amend', },
            { '<leader>gap', ':lua Maorun.git.amendPush()<cr>',                             desc = 'Amend and Push', },
            { '<leader>gb',  group = 'Branches' },
            { '<leader>gbm', ':G branch -m ',                                               desc = 'Git branch move', },
            { '<leader>gbn', ':lua Maorun.git.newBranch()<cr>',                             desc = 'Git New Branch', },
            { '<leader>gf',  ':G fetch --prune<cr>',                                        desc = 'Git Fetch', },
            { '<leader>gl',  ':lua Maorun.git.log()<cr>',                                   desc = 'Git Log', },
            { '<leader>gn',  ':lua Maorun.git.newBranch()<cr>',                             desc = 'Git New Branch', },
            { '<leader>gp',  group = 'Push & Pull' },
            { '<leader>gpf', ':lua Maorun.git.pushForce()<cr>',                             desc = 'Force Push', },
            { '<leader>gpp', ':lua Maorun.git.push()<cr>',                                  desc = 'Push', },
            { '<leader>gpu', ':G pull<cr>',                                                 desc = 'Pull', },
            { '<leader>gr',  group = 'Git Rebase' },
            { '<leader>grM', ':G fetch --prune | :G merge origin/master<cr>',               desc = 'Git Merge master', },
            { '<leader>grA', ':G merge --abort<cr>',                                        desc = 'Git Merge abort', },
            { '<leader>grC', ':G merge --continue<cr>',                                     desc = 'Git Merge continue', },
            { '<leader>gra', ':G rebase --abort<cr>',                                       desc = 'Git Rebase abort', },
            { '<leader>grc', ':G rebase --continue<cr>',                                    desc = 'Git Rebase continue', },
            { '<leader>grm', ':G fetch --prune | :G rebase origin/master<cr>',              desc = 'Git Rebase master', },
            { '<leader>grn', ':G rebase ',                                                  desc = 'Git Rebase', },
            { '<leader>gro', ':lua Maorun.git.resetToOrigin()<cr>',                         desc = 'Git Reset origin', },
            { '<leader>grr', ':G rebase -i HEAD~',                                          desc = 'Git Rebase interactive', },
            { '<leader>gs',  group = 'Git Stash' },
            { '<leader>gsa', ':G stash<cr>',                                                desc = 'Git Stash add', },
            { '<leader>gsp', ':G stash pop<cr>',                                            desc = 'Git Stash pop', },
            { '<leader>gw',  ":G commit --no-verify -m 'wip' | :lua Maorun.git.push()<cr>", desc = 'WIP', },
        },
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
            local wk = require('which-key')
            require('gitsigns').setup {
                current_line_blame = true,
                on_attach = function()
                    local gs = package.loaded.gitsigns

                    wk.add({
                        { '<leader>d',  group = 'Diff' },
                        { '<leader>dd', ':diffthis<cr>',                              desc = 'Diff this', },
                        { '<leader>dq', ':diffoff!<cr>',                              desc = 'Diff off', },
                        { '<leader>dh', ':diffget :2<cr>',                            desc = 'get right diff', },
                        { '<leader>dl', ':diffget :3<cr>',                            desc = 'get left diff', },
                        { '<leader>ds', ':Gitsigns diffthis<cr>',                     desc = 'Diffthis', },
                        { '<leader>h',  group = 'git Hunk' },
                        { '<leader>hA', gs.stage_buffer,                              desc = 'Stage Buffer', },
                        { '<leader>hD', function() gs.blame_line { full = true } end, desc = 'Diff This (ignore whitespace)', },
                        { '<leader>hR', gs.reset_buffer,                              desc = 'Reset Buffer', },
                        { '<leader>hS', gs.stage_buffer,                              desc = 'Stage Buffer', },
                        { '<leader>ha', gs.stage_hunk,                                desc = 'Stage Hunk', },
                        { '<leader>hb', function() gs.blame_line { full = true } end, desc = 'Blame Line', },
                        { '<leader>hd', gs.diffthis,                                  desc = 'Diff This', },
                        { '<leader>hp', gs.preview_hunk,                              desc = 'Preview Hunk', },
                        { '<leader>hr', gs.reset_hunk,                                desc = 'Reset Hunk', },
                        { '<leader>hs', gs.stage_hunk,                                desc = 'Stage Hunk', },
                        { '<leader>hu', gs.undo_stage_hunk,                           desc = 'Undo Stage Hunk', },
                    })
                    wk.add({
                        {
                            ']h',
                            function()
                                if vim.wo.diff then return ']c' end
                                vim.schedule(function() gs.next_hunk() end)
                                return '<Ignore>'
                            end,
                            desc = 'Next Hunk',
                            expr = true,
                            replace_keycodes = false
                        },
                        {
                            '[h',
                            function()
                                if vim.wo.diff then return '[c' end
                                vim.schedule(function() gs.prev_hunk() end)
                                return '<Ignore>'
                            end,
                            desc = 'Prev Hunk',
                            expr = true,
                            replace_keycodes = false
                        },
                    })
                    wk.add({
                        { '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, desc = 'Reset Hunk', mode = 'v', },
                        { '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, desc = 'Stage Hunk', mode = 'v', },
                    })

                    wk.add({
                        { 'ih', ':<C-U>Gitsigns select_hunk<CR>', desc = 'Select Hunk', mode = { 'o', 'x' }, },
                    })
                end
            }
        end
    },
    {
        'sindrets/diffview.nvim',
        keys = {
            { '<leader>dd', ':DiffviewOpen<cr>',                   desc = 'Diffview Open' },
            { '<leader>dq', ':DiffviewClose<cr>',                  desc = 'Diffview Close' },
            { '<leader>df', ':DiffviewFileHistory %<cr>',          desc = 'Diffview File History' },
            { '<leader>d',  '<cmd>\'<,\'>DiffviewFileHistory<cr>', desc = 'Diffview File History', mode = 'v' },
        },
    },
}
