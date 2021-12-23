let mapleader=" "

" Bug in Vim 8 => https://github.com/vim/vim/issues/4738
nnoremap gx yiW:!open <cWORD><CR><CR>

" with Esc on Nop : no arrow-keys in insert-mode (autocomplete)
" inoremap <Esc> <Nop> 

" Project-vimrc {{{
if filereadable(expand(".vimrc_project"))
    autocmd VimEnter * source .vimrc_project
endif
" }}}

" Session-Handling {{{
function LoadSession()
    if filereadable(expand("Session.vim"))
        source Session.vim "from vim-obsession
    endif
endfunction
" autocmd VimEnter * call LoadSession()

nnoremap <silent> <leader>ss :call LoadSession()<cr>:echo "Session loaded"<cr>
nnoremap <leader>sesss :Obsession<cr>
nnoremap <leader>sessd :Obsession!<cr>
" }}}

" AppleScript{{{
function CallAppleScript(application, command)
    :silent execute "!osascript -e 'tell application \"" . a:application ."\"' -e '" . a:command . "' -e 'end tell' >> /dev/null &"
    :redraw!
endfunction
command! TunnelblickStart :call CallAppleScript("/Applications/Tunnelblick.app", 'connect "openvpn"')
command! TunnelblickStop :call CallAppleScript("/Applications/Tunnelblick.app", 'disconnect "openvpn"')
command! SpotifyToggle :call CallAppleScript("Spotify", "playpause")
"}}}

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

function StartUp ()
    :TunnelblickStart
    let choice = confirm("Spotify ?", "&Yes\n&No\n", 2)
    if choice == 1
        :call CallAppleScript("Spotify", "play")
    endif

    :call CallAppleScript('Microsoft Outlook', 'activate')
    :call CallAppleScript('Microsoft Teams', 'activate')
endfunction
command! StartUp :call StartUp()

function! ShowCmdInNewBuffer (cmd) abort "{{{
    let res = system(a:cmd)
    :call NewBuffer()
    silent put=res
    :normal gg
    silent :normal dd
endfunction "}}}

" finding files
set path+=**
set wildmode=longest,list,full
set wildmenu
set wildignore+=**/node_modules/*,**/vendor/*

" CTAGS
command! MakeTags execute "!ctags -R --exclude=node_modules --exclude=vendor . &" | redraw! | echom "CTAGS generated"
augroup CTags
    autocmd!
    autocmd BufWritePost * silent execute "!ctags -a %"
augroup END

" File Browsing {{{
augroup ProjectDrawer
    autocmd!
    " autocmd VimEnter * :Vexplore
    autocmd VimEnter * :NERDTree
    autocmd VimEnter * wincmd l
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
let g:netrw_winsize = 25
let g:netrw_keepdir=0
let g:netrw_banner=0  		" 0 = disable top-banner
let g:netrw_browse_split=4 	" open in prior window
let g:netrw_altv=1		" open splits to the right
let g:netrw_liststyle=3		" tree-view
" }}}

set nofoldenable
set foldmethod=indent
augroup VimRcRead
    autocmd!
    autocmd BufRead .vimrc* setlocal foldmethod=marker
    autocmd BufRead .vimrc* setlocal foldenable
    autocmd BufRead *.json setlocal foldmethod=syntax
augroup END

autocmd BufRead *.txt setlocal nospell spelllang=de,en foldmethod=marker foldenable

" z= = suggest word
" zg = add word under cursor to good word in 'spellfile'
" zug = undo zg
" ]s = next misspelled word

" vim-dadbod fold result
autocmd FileType dbout setlocal nofoldenable

autocmd FileType typescriptreact setlocal formatprg=prettier\ --parser\ typescript
autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

"set clipboard^=unnamed,unnamedplus
syntax enable
set number
:set relativenumber
:set showcmd
:set title
:set ruler
:set cursorline
:set splitright splitbelow
set wrap
set scrolloff=5
set laststatus=2

set list
set listchars=tab:!·,trail:·

" completion
set complete+=kspell

" searching
:set hls
:set incsearch
set ignorecase
set smartcase
nnoremap <silent> <BS> :nohlsearch<cr>


" Color column
:set colorcolumn=	"80,120
:hi ColorColumn ctermbg=green
:call matchadd('ColorColumn', '\%81v', 100)

nnoremap go o<Esc>
nnoremap gO O<Esc>
nnoremap <leader>w mw:w<cr>:e<cr>`wzv
inoremap ;w <Esc>mw:w<cr>:e<cr>`wzva
nnoremap <C-E> <C-B>
inoremap jk <Esc>
vnoremap jk <Esc>
cnoremap jk <Esc>

:nnoremap <leader>ev :tabnew $MYVIMRC<cr>

:noremap <Leader>n :cn<Enter>zzzv
:noremap <leader>b :cp<Enter>zzzv
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
inoremap <C-j> <Esc>mk:m .+1<cr>==`ka
inoremap <C-k> <Esc>mk:m .-2<cr>==`ka
nnoremap <leader>k mk:m .-2<cr>==`k
nnoremap <leader>j mk:m .+1<cr>==`k

" undo break-points
" inoremap , ,<C-g>u
" inoremap . .<C-g>u
" inoremap ! !<C-g>u
" inoremap ? ?<C-g>u

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on

function NewBuffer () abort
    enew! "new buffer"
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
endfunction

command! Snip :tabnew | :call NewBuffer()
command! BufferAllWipeout :%bd|e#

let g:hardtime_default_on = 0
let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
" 
" Plugins {{{
" vim plugins
if empty(glob('~/.vim/autoload/plug.vim'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/nvim/plugged')
Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

Plug 'junegunn/vim-plug'
" common
"Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
"Plug 'ludovicchabant/vim-gutentags'

" Vim HardTime
Plug 'takac/vim-hardtime'

" Plug 'bfredl/nvim-miniyank'
"Plug 'moll/vim-bbye'
"Plug 'itchyny/lightline.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
" project-management
"Plug 'amiorin/vim-project'
"Plug 'mhinz/vim-startify'
" syntax
" Plug 'vim-scripts/phpfolding.vim'
" Plug 'StanAngeloff/php.vim'
"Plug 'stephpy/vim-php-cs-fixer'
" autocomplete
"Plug 'ncm2/ncm2'
"Plug 'phpactor/phpactor'
"Plug 'phpactor/ncm2-phpactor'
"" code quality
"Plug 'neomake/neomake'
"" refactor
"Plug 'adoy/vim-php-refactoring-toolbox'
"Plug 'phpactor/phpactor'
" git plugins
Plug 'tpope/vim-repeat' " repeat all plugins with .
Plug 'tpope/vim-fugitive' " Git
Plug 'tpope/vim-rhubarb' " enable :GBrowse to github
Plug 'tpope/vim-dadbod' " Database
Plug 'kristijanhusak/vim-dadbod-ui' " Database-UI
"Plug 'mhinz/vim-signify'
Plug 'vim-scripts/ReplaceWithRegister' " replace with register - gr
" outline
"Plug 'majutsushi/tagbar'
" debugger
"Plug 'joonty/vdebug'
" For Docker
" let g:vdebug_options["path_maps"] = {
"    \       "/mySuperProject": "/home/mySuperUser/workspace/mySuperProject"
"    \}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}

" graphql
Plug 'jparise/vim-graphql'

" typescript
Plug 'leafgarland/typescript-vim'
call plug#end()
" }}}
nnoremap <leader>fp /Plugins {{/<cr>zo:nohlsearch<cr>

" Git {{{
if has("autocmd")
augroup fugitive
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
endif

command! GW :wa | :G add -A | :G commit -m "wip" | :GP
command! GP :execute ":G push origin " . fugitive#head() | :execute ":G branch --set-upstream-to=origin/" . fugitive#head() . " " . fugitive#head()
command! GPF :execute ":G push --force origin " . fugitive#head()
command! GA :G add -A | :G commit --amend
command! GAP :execute "GA" | :GPF
command! GR :G fetch | :G rebase origin/master
command! GL :GlLog --invert-grep --grep Automated --grep "Phoenix"
command! -nargs=+ GN :silent execute ":G fetch | :G checkout origin/master | :G switch -c "<q-args>
" }}}

nnoremap <leader>gf :GFiles<cr>
nnoremap <leader>gr :Rg<cr>

set statusline=
set statusline+=%<
set statusline+=%f
set statusline+=\ %h " help-buffer
set statusline+=%m " modified-flag
set statusline+=%r " read-onlyflag
set statusline+=%{FugitiveStatusline()}
set statusline+=%=
set statusline+=Session:\ %{ObsessionStatus('[active]','[paused]')}
set statusline+=\ %-14.(%l,%c%V%)\ %P
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent> <leader>sv :wa<cr>:source $MYVIMRC<cr>:echo "~/.vimrc loaded"<cr>
augroup vimrc
    au!
    au! BufWritePost $MYVIMRC silent source $MYVIMRC | redraw! | echo $MYVIMRC . " reloaded"
    au! BufWritePost .vimrc_project source $MYVIMRC | redraw! | echo $MYVIMRC . ' reloaded'
augroup END

let g:codestats_api_key = 'SFMyNTY.YldGdmNuVnUjI01USTJNVGM9.KmdqdO96Ye-0Sgf0EQIKglU3BicSkfm55l5o5AmuIQ8'

" not waiting too long
set updatetime=500

"{{{ Coc-Configs
noremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ coc#refresh()
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif
highlight CocFloating ctermbg=black
" let g:coc_start_at_startup = v:false
set shortmess+=c

"{{{ Coc Float scrolling
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
"}}}

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gs <Plug>(coc-references)
nmap <leader>gi <Plug>(coc-implementation)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


function! ShowDocIfNoDiagnostic()
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
    call ShowDocIfNoDiagnostic()
  " call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

augroup Cursor
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
    autocmd CursorHoldI * :call <SID>show_hover_doc()
    autocmd CursorHold * :call <SID>show_hover_doc()
augroup END
"}}}

autocmd FileType typescriptreact setlocal signcolumn=yes
autocmd FileType typescript setlocal signcolumn=yes

nohlsearch

"{{{ Template-Logik
ab pubf public function
ab privf private function
ab protf protected function

inoremap <leader>tt <Esc>/<++><cr>zzzvcf>
function! GetTemplate (type)
    :execute "r ~/.vim/templates/" . a:type .".tpl"
    :normal kdd
    let @/ = '<++>'
    :normal nzzzvcf>
endfunction
command! TplClass :call GetTemplate('class')
command! -nargs=1 Tpl :call GetTemplate(<q-args>)
"}}}

if exists("*PostVimRc")
    :call PostVimRc()
endif
