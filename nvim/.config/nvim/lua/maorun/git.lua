vim.cmd [[
    augroup fugitive
        autocmd BufReadPost fugitive://* set bufhidden=delete
        " vim-dadbod fold result
        autocmd FileType dbout setlocal nofoldenable
        autocmd User DBUIOpened setlocal relativenumber number
    augroup END
]]

local wk = require("which-key")
wk.register({
    g = {
        name = "Git",
        w = {":wa | :G add -A | :G commit -m 'wip'<cr>", "WIP", noremap = true},
        p = {
            name = "Push",
            p = {":lua require('maorun.git').push()<cr>", "Push", noremap = true},
            f = {":lua require('maorun.git').pushForce()<cr>", "Force Push", noremap = true},
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
            m = {":G fetch --prune | :G rebase origin/master", "Git Rebase", noremap = true},
            r = {":G rebase -i HEAD~", "Git Rebase interactive", noremap = true},
        },
        l = {":lua require('maorun.git').log()<cr>", "Git Log", noremap = true},
        n = {":lua require('maorun.git').newBranch()<cr>", "Git New Branch", noremap = true},
        f = {":G fetch --prune", "Git Fetch", noremap = true},
    },
    d = {
        name = "Diff",
        h = {":diffget //2<cr>", "get right diff", noremap = true},
        l = {":diffget //3<cr>", "get left diff", noremap = true},
    },
    -- nnoremap ]c ]czz
    -- nnoremap [c [czz
}, { prefix = "<leader>" })

local M = {}
function M.log()
        -- :GlLog --invert-grep --grep Automated --grep Phoenix
    vim.cmd [[
        :Flogsplit -all -date=short
        :execute "/HEAD -> " . fugitive#head()
        :nohlsearch
    ]]
end
function M.amend()
    vim.cmd [[
        :w
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
    vim.cmd(string.format(":G checkout -b %s origin/master", branch))
end
function M.amendPush()
    M.amend()
    M.pushForce()
end
function M.push()
    vim.cmd [[
        :execute ":G push origin " . fugitive#head()
        :execute ":G branch --set-upstream-to=origin/" . fugitive#head() . " " . fugitive#head()
    ]]
end
function M.pushForce()
    vim.cmd [[
        :execute ":G push --force origin " . fugitive#head()
    ]]
end
return M
