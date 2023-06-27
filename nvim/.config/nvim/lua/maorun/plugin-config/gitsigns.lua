local wk = require("which-key")
require('gitsigns').setup {
    current_line_blame = true,
    on_attach = function()
        local gs = package.loaded.gitsigns

        wk.register({
            h = {
                name = "git Hunk",
                s = {gs.stage_hunk, "Stage Hunk", noremap =true},
                r= { gs.reset_hunk, "Reset Hunk", noremap = true},
                S={ gs.stage_buffer, "Stage Buffer", noremap = true},
                u={ gs.undo_stage_hunk, "Undo Stage Hunk", noremap = true},
                R={ gs.reset_buffer, "Reset Buffer", noremap = true},
                p={ gs.preview_hunk, "Preview Hunk", noremap = true},
                b={ function() gs.blame_line{full=true} end, "Blame Line", noremap = true},
                d={ gs.diffthis, "Diff This", noremap = true},
                D={ function() gs.diffthis('~') end, "Diff This (ignore whitespace)", noremap = true},
            },
        }, { prefix = "<leader>"})
        wk.register({
            ["]h"] = {function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, "Next Hunk", noremap = true, expr = true},
            ["[h"] = {function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, "Prev Hunk", noremap = true, expr = true},
        })
        wk.register({
            h = {
                s = {function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage Hunk", noremap =true},
                r= {function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset Hunk", noremap = true},
            },
        }, { prefix = "<leader>", mode = 'v'})

        wk.register({
            ih = {':<C-U>Gitsigns select_hunk<CR>', "Select Hunk", noremap = true},
        }, { prefix = "", mode = {'o', 'x'}})
    end
}
