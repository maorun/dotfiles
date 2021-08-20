let mapleader=" "

" Bug in Vim 8 => https://github.com/vim/vim/issues/4738
nnoremap gx yiW:!open <cWORD><CR><CR>

" with Esc on Nop : no arrow-keys in insert-mode (autocomplete)
" inoremap <Esc> <Nop> 

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

" AppleScript{{{
function CallAppleScript(application, command)
    :silent execute "!osascript -e 'tell application \"" . a:application ."\"' -e '" . a:command . "' -e 'end tell' >> /dev/null &"
    :redraw!
endfunction
command! TunnelblickStart :call CallAppleScript("/Applications/Tunnelblick.app", 'connect "openvpn"')
command! TunnelblickStop :call CallAppleScript("/Applications/Tunnelblick.app", 'disconnect "openvpn"')
command! SpotifyToggle :call CallAppleScript("Spotify", "playpause")
"}}}

function StartUp ()
    :TunnelblickStart
    :call CallAppleScript("Spotify", "play")
    :call CallAppleScript('Microsoft Outlook', 'activate')
    :call CallAppleScript('Microsoft Teams', 'activate')
endfunction
command! StartUp :call StartUp()

" finding files
set path+=**
set wildmenu

" CTAGS
command! MakeTags silent execute "!ctags -R --exclude=node_modules --exclude=vendor . &" | redraw! | echom "CTAGS generated"

" File Browsing {{{
let g:netrw_banner=0  		" 0 = disable top-banner
let g:netrw_browse_split=4 	" open in prior window
let g:netrw_altv=1		" open splits to the right
let g:netrw_liststyle=3		" tree-view
" }}}

set nofoldenable
set foldmethod=indent
autocmd BufRead .vimrc* :set foldmethod=marker
autocmd BufRead .vimrc* :set foldenable
autocmd BufRead *.json :set foldmethod=syntax

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
set smartcase
nnoremap <silent> <BS> :nohlsearch<cr>


" Color column
:set colorcolumn=	"80,120
:hi ColorColumn ctermbg=green
:call matchadd('ColorColumn', '\%81v', 100)

nnoremap go o<Esc>
nnoremap gO O<Esc>
nnoremap ;; :
nnoremap ;w mw:w<cr>:e<cr>`w
nnoremap <C-E> <C-B>
cnoremap ww w<cr>
inoremap jk <Esc>

nnoremap <leader>chea :50vs ~/.vim/cheatsheet.vim<cr><C-W>w
:nnoremap <leader>ev :tabnew $MYVIMRC<cr>

noremap <leader>te :tabfind<Space>**/
noremap ]te :tabfind<Space>**/
noremap <leader>vs :vs<Space>**/

:noremap <Leader>n :cn<Enter>
:noremap <leader>p :cp<Enter>
:noremap <leader>w :w<Enter>
:noremap <leader>wa :wa<Enter>
nnoremap <leader>fj :%!jq .<Enter>
noremap <leader>h :tab h<Space>
nnoremap <leader>] :silent execute "grep! -R " . shellescape(expand("<cword>")) . " . "<cr>:copen<cr><C-L>
nnoremap n nzzzv
nnoremap N Nzzzv

" moving lines
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
inoremap <C-j> <Esc>mk:m .+1<cr>==`ka
inoremap <C-k> <Esc>mk:m .-2<cr>==`ka
nnoremap <leader>k mk:m .-2<cr>==`k
nnoremap <leader>j mk:m .+1<cr>==`k

" undo break-points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

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
Plug 'tpope/vim-surround'
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
Plug 'tpope/vim-rhubarb' " enable :GBrowse to github
Plug 'tpope/vim-dadbod' " Database
Plug 'kristijanhusak/vim-dadbod-ui' " Database-UI
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
augroup fugitive
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
endif
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
command! GW :wa | :G add . | :G commit -m "wip" | :G push
command! GP :execute ":G push origin " . fugitive#head()
command! GPF :execute ":G push --force origin " . fugitive#head()
command! GA :G add . | :G commit --amend
command! GAP :GA | :GPF
command! GR :G fetch | :G rebase origin/master
command! GL :GlLog --invert-grep --grep Automated --grep "Phoenix"
command! -nargs=+ GN :G fetch | :G checkout origin/master | :G switch -c <q-args>
" }}}

nnoremap <silent> <leader>sv :wa<cr>:source $MYVIMRC<cr>:echo "~/.vimrc loaded"<cr>
augroup vimrc
    au!
    au! BufWritePost $MYVIMRC silent source $MYVIMRC | redraw! | echo $MYVIMRC . " reloaded"
    au! BufWritePost .vimrc_project source $MYVIMRC | redraw! | echo $MYVIMRC . ' reloaded'
augroup END

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
nohlsearch

if exists("*PostVimRc")
    :call PostVimRc()
endif
