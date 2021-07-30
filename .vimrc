" Bug in Vim 8 => https://github.com/vim/vim/issues/4738
nnoremap gx yiW:!open <cWORD><CR><CR>

inoremap jk <Esc>

" Project-vimrc {{{
if filereadable(expand(".vimrc_project"))
    :source .vimrc_project
endif
" }}}

" Session-Handling {{{
function LoadSession()
if filereadable(expand("Session.vim"))
:source Session.vim "from vim-obsession
endif
endfunction

nnoremap <silent> <leader>s :call LoadSession()<cr>:echo "Session loaded"<cr>
nnoremap <leader>sesss :Obsession<cr>
nnoremap <leader>sessd :Obsession!<cr>
" }}}

syntax enable
"set clipboard^=unnamed,unnamedplus

" finding files
set path+=**
set wildmenu

" CTAGS
command! MakeTags !ctags -R --exclude=node_modules --exclude=vendor .

" File Browsing {{{
let g:netrw_banner=1  		" 0 = disable top-banner
let g:netrw_browse_split=4 	" open in prior window
let g:netrw_altv=1		" open splits to the right
let g:netrw_liststyle=3		" tree-view
" }}}

:set foldmethod=marker
:set relativenumber
:set showcmd
:set title
:set ruler
:set cul
:set splitright
:set splitbelow

" searching
:set hls
:set incsearch
set ignorecase
nnoremap <silent> <BS> :nohlsearch<cr>


" Color column
:set colorcolumn=	"80,120
:hi ColorColumn ctermbg=green
:call matchadd('ColorColumn', '\%81v', 100)

nnoremap <leader>chea :50vs ~/.vim/cheatsheet.vim<cr><C-W>w
nnoremap <silent> <leader>sv :wa<cr>:source $MYVIMRC<cr>:echo "~/.vimrc loaded"<cr>
:nnoremap <leader>ev :tabnew $MYVIMRC<cr>

noremap <leader>te :tabfind<Space>**/
noremap ]te :tabfind<Space>**/
noremap <leader>vs :vs<Space>**/

:noremap <Leader>n :cn<Enter>
:noremap <leader>p :cp<Enter>
:noremap <leader>w :w<Enter>
:noremap <leader>wa :wa<Enter>

noremap <leader>h :tab h<Space>

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

command! GW :wa | :G add . | :G commit -m "wip" | :G push
command! GP :G push --force
command! GA :G add . | :G commit --amend
command! GAP :GA | :GP
command! GR :G rebase origin/master
command! GL :G log --invert-grep --grep Automated --grep "Phoenix" --oneline --decorate
command! -nargs=+ GN :G checkout origin/master | :G switch -c <q-args>

let g:hardtime_default_on = 1
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
"Plug 'junegunn/fzf'
"Plug 'scrooloose/nerdtree'
"Plug 'ludovicchabant/vim-gutentags'

" Vim HardTime
Plug 'takac/vim-hardtime'

" Plug 'bfredl/nvim-miniyank'
"Plug 'moll/vim-bbye'
"Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
" project-management
"Plug 'amiorin/vim-project'
"Plug 'mhinz/vim-startify'
" syntax
"Plug 'StanAngeloff/php.vim'
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
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
"Plug 'mhinz/vim-signify'
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
call plug#end()
" }}}
nnoremap <leader>fp /Plugins {{/<cr>zo:nohlsearch<cr>

" Git {{{
if has("autocmd")
    autocmd BufReadPost fugitive://* set bufhidden=delete
endif
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
" }}}

let g:codestats_api_key = 'SFMyNTY.YldGdmNuVnUjI01USTJNVGM9.KmdqdO96Ye-0Sgf0EQIKglU3BicSkfm55l5o5AmuIQ8'

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

