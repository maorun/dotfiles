return {
    {
        'tpope/vim-fugitive',
        event = 'VimEnter',
        keys = {
            { '<leader>g',   group = 'Git' },
            { '<leader>ga',  group = 'Amend' },
            { '<leader>gaa', ':lua Maorun.git.amend()<cr>',                                 desc = 'Amend',                  remap = false },
            { '<leader>gap', ':lua Maorun.git.amendPush()<cr>',                             desc = 'Amend and Push',         remap = false },
            { '<leader>gb',  group = 'Branches' },
            { '<leader>gbm', ':G branch -m ',                                               desc = 'Git branch move',        remap = false },
            { '<leader>gbn', ':lua Maorun.git.newBranch()<cr>',                             desc = 'Git New Branch',         remap = false },
            { '<leader>gf',  ':G fetch --prune<cr>',                                        desc = 'Git Fetch',              remap = false },
            { '<leader>gl',  ':lua Maorun.git.log()<cr>',                                   desc = 'Git Log',                remap = false },
            { '<leader>gn',  ':lua Maorun.git.newBranch()<cr>',                             desc = 'Git New Branch',         remap = false },
            { '<leader>gp',  group = 'Push & Pull' },
            { '<leader>gpf', ':lua Maorun.git.pushForce()<cr>',                             desc = 'Force Push',             remap = false },
            { '<leader>gpp', ':lua Maorun.git.push()<cr>',                                  desc = 'Push',                   remap = false },
            { '<leader>gpu', ':G pull<cr>',                                                 desc = 'Pull',                   remap = false },
            { '<leader>gr',  group = 'Git Rebase' },
            { '<leader>grM', ':G fetch --prune | :G merge origin/master<cr>',               desc = 'Git Merge master',       remap = false },
            { '<leader>grA', ':G merge --abort<cr>',                                        desc = 'Git Merge abort',       remap = false },
            { '<leader>grC', ':G merge --continue<cr>',                                     desc = 'Git Merge continue',    remap = false },
            { '<leader>gra', ':G rebase --abort<cr>',                                       desc = 'Git Rebase abort',       remap = false },
            { '<leader>grc', ':G rebase --continue<cr>',                                    desc = 'Git Rebase continue',    remap = false },
            { '<leader>grm', ':G fetch --prune | :G rebase origin/master<cr>',              desc = 'Git Rebase master',      remap = false },
            { '<leader>grn', ':G rebase ',                                                  desc = 'Git Rebase',             remap = false },
            { '<leader>gro', ':lua Maorun.git.resetToOrigin()<cr>',                         desc = 'Git Reset origin',       remap = false },
            { '<leader>grr', ':G rebase -i HEAD~',                                          desc = 'Git Rebase interactive', remap = false },
            { '<leader>gs',  group = 'Git Stash' },
            { '<leader>gsa', ':G stash<cr>',                                                desc = 'Git Stash add',          remap = false },
            { '<leader>gsp', ':G stash pop<cr>',                                            desc = 'Git Stash pop',          remap = false },
            { '<leader>gw',  ":G commit --no-verify -m 'wip' | :lua Maorun.git.push()<cr>", desc = 'WIP',                    remap = false },
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
                        { '<leader>dd', ':diffthis<cr>',                              desc = 'Diff this',                     remap = false },
                        { '<leader>dq', ':diffoff!<cr>',                              desc = 'Diff off',                      remap = false },
                        { '<leader>dh', ':diffget :2<cr>',                            desc = 'get right diff',                remap = true },
                        { '<leader>dl', ':diffget :3<cr>',                            desc = 'get left diff',                 remap = true },
                        { '<leader>ds', ':Gitsigns diffthis<cr>',                     desc = 'Diffthis',                      remap = true },
                        { '<leader>h',  group = 'git Hunk' },
                        { '<leader>hA', gs.stage_buffer,                              desc = 'Stage Buffer',                  remap = true },
                        { '<leader>hD', function() gs.blame_line { full = true } end, desc = 'Diff This (ignore whitespace)', remap = true },
                        { '<leader>hR', gs.reset_buffer,                              desc = 'Reset Buffer',                  remap = true },
                        { '<leader>hS', gs.stage_buffer,                              desc = 'Stage Buffer',                  remap = true },
                        { '<leader>ha', gs.stage_hunk,                                desc = 'Stage Hunk',                    remap = true },
                        { '<leader>hb', function() gs.blame_line { full = true } end, desc = 'Blame Line',                    remap = true },
                        { '<leader>hd', gs.diffthis,                                  desc = 'Diff This',                     remap = true },
                        { '<leader>hp', gs.preview_hunk,                              desc = 'Preview Hunk',                  remap = true },
                        { '<leader>hr', gs.reset_hunk,                                desc = 'Reset Hunk',                    remap = true },
                        { '<leader>hs', gs.stage_hunk,                                desc = 'Stage Hunk',                    remap = true },
                        { '<leader>hu', gs.undo_stage_hunk,                           desc = 'Undo Stage Hunk',               remap = true },
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
                            noremap = true,
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
                            noremap = true,
                            expr = true,
                            replace_keycodes = false
                        },
                    })
                    wk.add({
                        { '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, desc = 'Reset Hunk', mode = 'v', remap = false },
                        { '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, desc = 'Stage Hunk', mode = 'v', remap = false },
                    })

                    wk.add({
                        { 'ih', ':<C-U>Gitsigns select_hunk<CR>', desc = 'Select Hunk', mode = { 'o', 'x' }, remap = true },
                    })
                end
            }
        end
    },
    {
        'sindrets/diffview.nvim'
    },
    {
        -- o -> old version
        -- O -> new version
        'rhysd/git-messenger.vim',
        keys = {
            { '<c-w>m',     '<Plug>(git-messenger-into-popup)', desc = 'Git Messenger switch', remap = false },
            { '<leader>gm', ':GitMessenger<cr>',                desc = 'Git Messenger',        remap = false },
        }
    }
}
