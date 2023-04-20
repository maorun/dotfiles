local wk = require("which-key")
vim.cmd[[
    augroup ProjectDrawer
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    augroup END
    let NERDTreeShowHidden=1
    " enable line numbers
    let NERDTreeShowLineNumbers=1
    " make sure relative line numbers are used
    autocmd FileType nerdtree setlocal relativenumber
]]
wk.register({
    n = {
        name = "FileTree",
        n = {
            name = "NERDTree",
            f = {":NERDTreeFind<cr>", "current file", noremap = true },
            t = {":NERDTree<cr>", "open tree", noremap = true},
        },
    },
}, { prefix = "<leader>" })

