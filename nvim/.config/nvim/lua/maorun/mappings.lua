vim.g.mapleader = ' '

vim.cmd [[
function! LoadSession()
    if filereadable(expand("Session.vim"))
        source Session.vim "from vim-obsession
    endif
endfunction
]]
vim.cmd [[
    " got to indention level {{{
    function! s:indent_len(str)
        return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
    endfunction
    function! s:go_indent(times, dir)
        for _ in range(a:times)
            let l = line('.')
            let x = line('$')
            let i = s:indent_len(getline(l))
            let e = empty(getline(l))

            while l >= 1 && l <= x
                let line = getline(l + a:dir)
                let l += a:dir
                if s:indent_len(line) != i || empty(line) != e
                    break
                endif
            endwhile
            let l = min([max([1, l]), x])
            execute 'normal! '. l .'G^'
        endfor
    endfunction "}}}
    nnoremap <silent> <leader>i :<c-u>call <SID>go_indent(v:count1, 1)<cr>
    nnoremap <silent> <leader>pi :<c-u>call <SID>go_indent(v:count1, -1)<cr>
]]

local wk = require("which-key")

wk.register({
    ['<BS>'] = {":nohlsearch<cr>", "clear Search", noremap = true},
    ['<C-E>'] = {"<C-B>", "Scroll up"},
    g = {
        o = {"o<Esc>", "add a line below", noremap = true},
        O = {"O<Esc>", "add a line above", noremap = true},
    },
    n = {"nzzv"},
    N = {"Nzzv"},
    ["¡"] = {"<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "navigate to file 1", noremap = true},
    ["™"] = {"<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "navigate to file 2", noremap = true},
    ["£"] = {"<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "navigate to file 3", noremap = true},
    ["¢"] = {"<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "navigate to file 4", noremap = true},

}, { silent=true, prefix = '' })

wk.register({
    a = {":lua require('harpoon.mark').add_file()<cr>", "Add file to mark", noremap = true},
    w = {":w<cr>zvzz", "Save", noremap = true},
    v = {
        name = "VimRC",
        e = {":tabnew ~/dotfiles/nvim/.config/nvim/init.lua<cr>3gg0w", "load main vimrc", noremap = true},
        r = {":source $MYVIMRC<cr>:echo '~/.vimrc loaded'<cr>", "Load VimRC", noremap = true},
    },
    s = {
       name = "Session-Handling",
       s = {':call LoadSession()<cr>:echo "Session loaded"<cr>' , "Load Session", noremap = true},
    },
    f = {
        j = {":%!jq .<cr>" , "JSON pretty print", noremap = true},
    },
    i = { "go to next indent", noremap = true},
    pi = { "go to previous indent", noremap = true},
    e = {":execute '!' .(expand(getline('.')))<cr>", "execute line under cursor (shellescape does not work)", noremap = true},
}, { silent=true, prefix = '<leader>' })

wk.register({
    n = {
        name = "NERDTree",
        f = {":NERDTreeFind<cr>", "current file", noremap = true },
        t = {":NERDTree<cr>", "open tree", noremap = true},
    },
    c = {
        name = "COC",
        ["a"] = {"<Plug>(coc-codeaction)", "open coc", noremap = true},
        -- Apply AutoFix to problem on the current line.
        ["f"] = {"<Plug>(coc-fix-current)", "quickfix current problem", noremap = true },
        ["n"] = {"<plug>(coc-diagnostic-next)", "next problem", noremap = true },
        ["p"] = {"<Plug>(coc-diagnostic-prev)", "prev problem", noremap = true },
        ["r"] = {"<Plug>(coc-rename)", "rename", noremap = true },
        ["d"] = {"<Plug>(coc-definition)", "see definition", noremap = true },
        ["s"] = {"<Plug>(coc-references)", "see references", noremap = true },
        ["i"] = {"<Plug>(coc-implementation)", "goto implementations", noremap = true },
    },
}, { prefix = "<leader>" })

vim.cmd [[
    inoremap jk <Esc>
    vnoremap jk <Esc>
    cnoremap jk <Esc>

    "{{{ Coc-Configs

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif
    "{{{ Coc Float scrolling
    if has('nvim') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif
    "}}}

    " float-menu up and down
    inoremap <C-j> <Down>
    inoremap <C-k> <Up>

    " yank and paste to/from system-clipboard (Mac)
    vnoremap ç "+y
    nnoremap √ "+p
    inoremap √ <Esc>"+pa
]]
wk.register({
    ["<C-L>"] = { "<C-O>l", "move cursor right", noremap = true},
    ["<C-H>"] = { "<C-O>h", "move cursor left", noremap = true},
}, { mode = 'i'})

-- moving lines
wk.register({
    J = {":m '>+1<cr>gv=gv", "move line down", noremap = true},
    K = {":m '<-2<cr>gv=gv", "move line up", noremap = true},
}, { mode = 'v'})
wk.register({
    ["<C-J>"] = { "mk:m .+1<cr>==`k", "move line down", noremap = true},
    ["<C-K>"] = { "mk:m .-2<cr>==`k", "move line up", noremap = true},
}, { mode = 'n'})
wk.register({
    ["<C-J>"] = { "<Esc>mk:m .+1<cr>==`ka", "move line down", noremap = true},
    ["<C-K>"] = { "<Esc>mk:m .-2<cr>==`ka", "move line up", noremap = true},
}, { mode = 'i'})
