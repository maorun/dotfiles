return {
    {
        'tpope/vim-fugitive',
        init = function()
            local fugitiveAuGroup = vim.api.nvim_create_augroup("user_fugitive", {})
            vim.api.nvim_create_autocmd("BufReadPost", {
                group = fugitiveAuGroup,
                pattern = "fugitive://*",
                command = "set bufhidden=delete",
            })
            local wk = require("which-key")
            wk.register({
                g = {
                    name = "Git",
                    w = { ":G add -A | :G commit --no-verify -m 'wip' | :lua Maorun.git.push()<cr>", "WIP", noremap = true },
                    p = {
                        name = "Push & Pull",
                        p = { ":lua Maorun.git.push()<cr>", "Push", noremap = true },
                        f = { ":lua Maorun.git.pushForce()<cr>", "Force Push", noremap = true },
                        u = { ":G pull<cr>", "Pull", noremap = true },
                    },
                    a = {
                        name = "Amend",
                        a = { ":lua Maorun.git.amend()<cr>", "Amend", noremap = true },
                        p = { ":lua Maorun.git.amendPush()<cr>", "Amend and Push", noremap = true },
                    },
                    s = {
                        name = "Git Stash",
                        a = { ":G stash<cr>", "Git Stash add", noremap = true },
                        p = { ":G stash pop<cr>", "Git Stash pop", noremap = true },
                    },
                    b = {
                        name = "Branches",
                        m = { ":G branch -m ", "Git branch move", noremap = true },
                        n = { ":lua Maorun.git.newBranch()<cr>", "Git New Branch", noremap = true },
                    },
                    r = {
                        name = "Git Rebase",
                        m = { ":G fetch --prune | :G rebase origin/master<cr>", "Git Rebase master", noremap = true },
                        M = { ":G fetch --prune | :G merge origin/master<cr>", "Git Merge master", noremap = true },
                        r = { ":G rebase -i HEAD~", "Git Rebase interactive", noremap = true },
                        c = { ":G rebase --continue<cr>", "Git Rebase continue", noremap = true },
                        a = { ":G rebase --abort<cr>", "Git Rebase abort", noremap = true },
                        o = { ":lua Maorun.git.resetToOrigin()<cr>", "Git Reset origin", noremap = true },
                        n = { ":G rebase ", "Git Rebase", noremap = true },
                    },
                    m = { ":GitMessenger<cr>", "Git Messenger", noremap = true },
                    l = { ":lua Maorun.git.log()<cr>", "Git Log", noremap = true },
                    n = { ":lua Maorun.git.newBranch()<cr>", "Git New Branch", noremap = true },
                    f = { ":G fetch --prune<cr>", "Git Fetch", noremap = true },
                },

                -- nnoremap ]c ]czz
                -- nnoremap [c [czz
            }, { prefix = "<leader>" })

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
                local branch = vim.fn.input("New branch name: ")
                if branch == "" then
                    return
                end
                vim.cmd(":G fetch --prune")
                -- create branch
                vim.cmd(string.format(":G branch %s origin/master", branch))
                vim.cmd(string.format(":G checkout %s", branch))
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
            local wk = require("which-key")
            require('gitsigns').setup {
                current_line_blame = true,
                on_attach = function()
                    local gs = package.loaded.gitsigns

                    wk.register({
                        d = {
                            name = "Diff",
                            s = { ":Gitsigns diffthis<cr>", "Diffthis", noremap = true },
                            h = { ":diffget :2<cr>", "get right diff", noremap = true },
                            l = { ":diffget :3<cr>", "get left diff", noremap = true },
                        },
                        h = {
                            name = "git Hunk",
                            s = { gs.stage_hunk, "Stage Hunk", noremap = true },
                            a = { gs.stage_hunk, "Stage Hunk", noremap = true },
                            r = { gs.reset_hunk, "Reset Hunk", noremap = true },
                            S = { gs.stage_buffer, "Stage Buffer", noremap = true },
                            A = { gs.stage_buffer, "Stage Buffer", noremap = true },
                            u = { gs.undo_stage_hunk, "Undo Stage Hunk", noremap = true },
                            R = { gs.reset_buffer, "Reset Buffer", noremap = true },
                            p = { gs.preview_hunk, "Preview Hunk", noremap = true },
                            b = { function() gs.blame_line { full = true } end, "Blame Line", noremap = true },
                            d = { gs.diffthis, "Diff This", noremap = true },
                            D = { function() gs.diffthis('~') end, "Diff This (ignore whitespace)", noremap = true },
                        },
                    }, { prefix = "<leader>" })
                    wk.register({
                        ["]h"] = {
                            function()
                                if vim.wo.diff then return ']c' end
                                vim.schedule(function() gs.next_hunk() end)
                                return '<Ignore>'
                            end,
                            "Next Hunk",
                            noremap = true,
                            expr = true
                        },
                        ["[h"] = {
                            function()
                                if vim.wo.diff then return '[c' end
                                vim.schedule(function() gs.prev_hunk() end)
                                return '<Ignore>'
                            end,
                            "Prev Hunk",
                            noremap = true,
                            expr = true
                        },
                    })
                    wk.register({
                        h = {
                            s = { function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Stage Hunk", noremap = true },
                            r = { function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Reset Hunk", noremap = true },
                        },
                    }, { prefix = "<leader>", mode = 'v' })

                    wk.register({
                        ih = { ':<C-U>Gitsigns select_hunk<CR>', "Select Hunk", noremap = true },
                    }, { prefix = "", mode = { 'o', 'x' } })
                end
            }
        end
    },
    {
        -- o -> old version
        -- O -> new version
        'rhysd/git-messenger.vim',
        dependencies = {
            'folke/which-key.nvim',
        },
        init = function()
            local wk = require("which-key")

            wk.register({
                ["<c-w>"] = {
                    m = { "<Plug>(git-messenger-into-popup)", "Git Messenger switch", noremap = true },
                }
            }, {})
        end
    }
}
