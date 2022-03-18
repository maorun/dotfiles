let mapleader=" "

" Bug in Vim 8 => https://github.com/vim/vim/issues/4738
nnoremap gx yiW:!open <cWORD><CR><CR>

nnoremap <silent> <BS> :nohlsearch<cr>

" with Esc on Nop : no arrow-keys in insert-mode (autocomplete)
" inoremap <Esc> <Nop> 

" Session-Handling {{{
function! LoadSession()
    if filereadable(expand("Session.vim"))
        source Session.vim "from vim-obsession
    endif
endfunction
" autocmd VimEnter * call LoadSession()

nnoremap <silent> <leader>ss :call LoadSession()<cr>:echo "Session loaded"<cr>
nnoremap <leader>sesss :Obsession<cr>
nnoremap <leader>sessd :Obsession!<cr>
" }}}
"
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

nnoremap <leader>nf :NERDTreeFind<cr>
nnoremap <leader>nt :NERDTree<cr>

nnoremap go o<Esc>
nnoremap gO O<Esc>
nnoremap <leader>w :w<cr>:e<cr>zvzz
inoremap ;w <Esc>:w<cr>:e<cr>zva
nnoremap <C-E> <C-B>
inoremap jk <Esc>
vnoremap jk <Esc>
cnoremap jk <Esc>

nnoremap <leader>ev :tabnew ~/dotfiles/vim/.vimrc<cr><C-W>v:e ~/dotfiles/nvim/.config/nvim/init.vim<cr>3gg0w<c-w>w

noremap <Leader>n :cn<Enter>zzzv
noremap <leader>b :cp<Enter>zzzv
" format json
nnoremap <leader>fj :%!jq .<Enter>
" grep word under cursor
nnoremap <leader>] :silent execute "grep! -R " . shellescape(expand("<cword>")) . " . "<cr>:copen<cr><C-L>
nnoremap n nzzzv
nnoremap N Nzzzv
" execute line under cursor (shellescape does not work)
nnoremap <leader>ex :execute '!' .(expand(getline('.')))<cr>

" yank and paste to/from system-clipboard (Mac)
vnoremap ç "+y
nnoremap √ "+p
inoremap √ <Esc>"+pa

" moving lines
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
inoremap <C-S-j> <Esc>mk:m .+1<cr>==`ka
inoremap <C-S-k> <Esc>mk:m .-2<cr>==`ka
nnoremap <leader>k mk:m .-2<cr>==`k
nnoremap <leader>j mk:m .+1<cr>==`k

" undo break-points
" inoremap , ,<C-g>u
" inoremap . .<C-g>u
" inoremap ! !<C-g>u
" inoremap ? ?<C-g>u

nnoremap <leader>fp /Plugins {{/<cr>zo:nohlsearch<cr>

" {{{ FZF
" nnoremap <leader>gf :GFiles<cr>
" nnoremap <leader>gr :Rg<cr>
" }}}

" {{{ Telescope

nnoremap <leader><leader> <cmd>lua require'telescope.builtin'.git_files{}<cr>
nnoremap <leader>gg <cmd>lua require'telescope.builtin'.git_files{}<cr>
nnoremap <leader>gb <cmd>lua require'telescope.builtin'.git_branches{}<cr>
nnoremap <leader>tf <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>tr <cmd>lua require('telescope.builtin').live_grep()<cr>
" }}}

nnoremap <silent> <leader>sv :w<cr>:source $MYVIMRC<cr>:echo "~/.vimrc loaded"<cr>

"{{{ Coc-Configs
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>cn <plug>(coc-diagnostic-next)
nmap <leader>cp <Plug>(coc-diagnostic-prev)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>cr <Plug>(coc-references)
nmap <leader>gi <Plug>(coc-implementation)
" Formatting selected code.
xmap <leader>ff  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-format-selected)
"}}}

let g:w1 = @%
let g:w2 = @%
let g:w3 = @%
let g:w4 = @%
noremap <leader>a1 :let g:w1 = @%<cr>
noremap <leader>a2 :let g:w2 = @%<cr>:echo g:w2<cr>
noremap <leader>a3 :let g:w3 = @%<cr>:echo g:w3<cr>
noremap <leader>a4 :let g:w4 = @%<cr>:echo g:w4<cr>
function! OpenFileBasedOnGlobal(file)
    if (a:file != '')
        :execute "buffer ".a:file
    endif
endfunction
noremap ¡ :call OpenFileBasedOnGlobal(g:w1)<cr>
noremap ™ :call OpenFileBasedOnGlobal(g:w2)<cr>
noremap £ :call OpenFileBasedOnGlobal(g:w3)<cr>
noremap ¢ :call OpenFileBasedOnGlobal(g:w4)<cr>

" Template
inoremap ++ <Esc>/<++><cr>zzzvcf>

nnoremap <leader>of :Telescope colors<cr>

" Git
nnoremap <leader>gsa :G stash<cr>
nnoremap <leader>gsp :G stash pop<cr>
nnoremap <leader>grr :G rebase -i HEAD~
nnoremap <leader>grc :G rebase --continue<cr>
nnoremap <leader>gsl :G log -g stash
nnoremap <leader>ml :diffget //3<cr>
nnoremap <leader>mh :diffget //2<cr>

nnoremap ]c ]czz
nnoremap [c [czz
