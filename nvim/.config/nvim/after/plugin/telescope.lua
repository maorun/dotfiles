-- Load user extension
require('maorun.telescope.secrets').init()
require('maorun.telescope.k8s').init()

local wk = require("which-key")
wk.register({
    [ '<leader>' ] = { ":Telescope file_browser respect_gitignore=true<cr>", "ope file", noremap = true },
    t = {
        name = "Telescope",
        g = { ':GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>', "Google Keep", noremap = true },
        f = { ":lua require('telescope.builtin').find_files()<cr>", "Find files", noremap = true },
        r = { ":lua require('telescope.builtin').live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g', '!git/**'} }<cr>", "Live Grep", noremap = true },
        k = { ":Telescope k8s<cr>", "Kubernetes", noremap = true },
        s = { ":lua require('maorun.telescope.secrets').folders()<cr>", "Secrets", noremap = true },
        h = { ":Telescope harpoon marks<cr>", "Harpoon marks", noremap = true },
        p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "Project", noremap = true },
        l = { ":lua require('telescope.builtin').oldfiles()<cr>", "Find last opened files", noremap = true },
    },
    g = {
        name = "Git",
        s = {
            l = { ':Telescope git_stash<cr>', "Stash list", noremap = true },
        },
        g = { ":lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
        b = {
            name = "Branches",
            a = {":lua require'telescope.builtin'.git_branches()<cr>", "Git all branches", noremap = true },
            b = {":lua require'telescope.builtin'.git_branches({pattern = 'refs/heads'})<cr>", "Git lokal branches", noremap = true },
            r = {":lua require'telescope.builtin'.git_branches({pattern = 'refs/remotes'})<cr>", "Git remote branches", noremap = true },
        },
        h = {
            name = "GitHub",
            g = {':lua require("telescope").extensions.gh.gist()<cr>', "Gist", noremap = true},
        },
    },
    b = {
        name = "Buffer",
        b = {':lua require("telescope.builtin").buffers()<cr>', "show Buffers", noremap = true },
        d = {':%bd|e#<cr>', "delete all buffers", noremap = true },
    },
}, { prefix = "<leader>" })

