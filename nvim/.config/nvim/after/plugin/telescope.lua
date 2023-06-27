-- Load user extension
local wk = require("which-key")
wk.register({
    t = {
        name = "Telescope",
        f = { ":lua require('telescope.builtin').find_files()<cr>", "Find files", noremap = true },
        r = { ":lua require('telescope.builtin').live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g', '!git/**'} }<cr>", "Live Grep", noremap = true },
        p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "Project", noremap = true },
        l = { ":lua require('telescope.builtin').oldfiles({cwd_only=true})<cr>", "Find last opened files", noremap = true },
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

