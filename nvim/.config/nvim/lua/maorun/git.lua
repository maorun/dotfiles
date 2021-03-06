local fugitiveAuGroup = vim.api.nvim_create_augroup("user_fugitive", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = fugitiveAuGroup,
    pattern = "fugitive://*",
    command = "set bufhidden=delete",
})
vim.api.nvim_create_autocmd("FileType", {
    group = fugitiveAuGroup,
    pattern = "dbout",
    command = "setlocal nofoldenable",
})
vim.api.nvim_create_autocmd("User", {
    group = fugitiveAuGroup,
    pattern = "DBUIOpened",
    command = "setlocal relativenumber number",
})

local wk = require("which-key")
wk.register({
    g = {
        name = "Git",
        c = {":G add -A | :G commit<cr>", "Commit", noremap = true},
        w = {":w | :G add -A | :G commit -m 'wip'<cr>", "WIP", noremap = true},
        p = {
            name = "Push & Pull",
            p = {":lua require('maorun.git').push()<cr>", "Push", noremap = true},
            f = {":lua require('maorun.git').pushForce()<cr>", "Force Push", noremap = true},
            u = {":G pull<cr>", "Pull", noremap = true},
        },
        a = {
            name = "Amend",
            a = {":lua require('maorun.git').amend()<cr>", "Amend", noremap = true},
            p = {":lua require('maorun.git').amendPush()<cr>", "Amend and Push", noremap = true},
        },
        s = {
            name = "Git Stash",
            a = {":G stash<cr>", "Git Stash add", noremap = true},
            p = {":G stash pop<cr>", "Git Stash pop", noremap = true},
        },
        r = {
            name = "Git Rebase",
            m = {":G fetch --prune | :G rebase origin/master<cr>", "Git Rebase master", noremap = true},
            r = {":G rebase -i HEAD~", "Git Rebase interactive", noremap = true},
            c = {":G rebase --continue<cr>", "Git Rebase continue", noremap = true},
            o = {":lua require('maorun.git').resetToOrigin()<cr>", "Git Reset origin", noremap = true},
        },
        l = {":lua require('maorun.git').log()<cr>", "Git Log", noremap = true},
        n = {":lua require('maorun.git').newBranch()<cr>", "Git New Branch", noremap = true},
        f = {":G fetch --prune<cr>", "Git Fetch", noremap = true},
    },
    d = {
        name = "Diff",
        s = {":Gdiffsplit<cr>", "Diffsplit", noremap = true},
        h = {":diffget //2<cr>", "get right diff", noremap = true},
        l = {":diffget //3<cr>", "get left diff", noremap = true},
    },
    -- nnoremap ]c ]czz
    -- nnoremap [c [czz
}, { prefix = "<leader>" })

local M = {}
function M.resetToOrigin()
    vim.cmd(':execute ":G reset --hard origin/" . FugitiveHead()')
end
function M.log()
        -- :GlLog --invert-grep --grep Automated --grep Phoenix
    vim.cmd [[
        :Flogsplit -all -date=short
        :execute "/HEAD -> " . FugitiveHead()
        :nohlsearch
    ]]
end
function M.amend()
    vim.cmd [[
        :G add -A
        :G commit --amend --no-edit
    ]]
end
function M.newBranch()
    -- prompt for branch name
    local branch = vim.fn.input("New branch name: ")
    if branch == "" then
        return
    end
    vim.cmd(":G fetch --prune")
    -- create branch
    -- vim.cmd(string.format(":G checkout -b %s origin/master", branch))
    vim.cmd(string.format(":G branch %s origin/master", branch))
end
function M.amendPush()
    M.amend()
    M.pushForce()
end
function M.push()
    vim.cmd [[
        :execute ":G push origin " . FugitiveHead()
        :execute ":G branch --set-upstream-to=origin/" . FugitiveHead() . " " . FugitiveHead()
    ]]
end
function M.pushForce()
    vim.cmd [[
        :execute ":G push --force origin " . FugitiveHead()
    ]]
end
return M
