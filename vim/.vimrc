let $PATH = '/Users/mdriemel/.nvm/versions/node/v17.4.0/bin:' . $PATH

" Project-vimrc {{{
if filereadable(expand(".vimrc_project"))
    source .vimrc_project
endif
" }}}

" AppleScript{{{
function! CallAppleScript(application, command)
    :silent execute "!osascript -e 'tell application \"" . a:application ."\"' -e '" . a:command . "' -e 'end tell' >> /dev/null &"
    :redraw!
endfunction
command! TunnelblickStart :call CallAppleScript("/Applications/Tunnelblick.app", 'connect "openvpn"')
command! TunnelblickStop :call CallAppleScript("/Applications/Tunnelblick.app", 'disconnect "openvpn"')
command! SpotifyToggle :call CallAppleScript("Spotify", "playpause")
"}}}

function! StartUp ()
    :TunnelblickStart

    :call CallAppleScript('Microsoft Outlook', 'activate')
    :call CallAppleScript('Microsoft Teams', 'activate')
    :call CallAppleScript('Google Chrome', 'activate')

    let choice = confirm("Spotify ?", "&Yes\n&No\n", 2)
    if choice == 1
        :call CallAppleScript("Spotify", "play")
    endif
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
    " autocmd VimEnter * :NERDTree
    " autocmd VimEnter * wincmd l
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
let NERDTreeShowHidden=1
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

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
    autocmd FileType vim setlocal foldmethod=marker foldenable
    autocmd BufRead *.json setlocal foldmethod=syntax
augroup END

autocmd BufRead *.txt setlocal nospell spelllang=de,en foldmethod=marker foldenable

" z= = suggest word
" zg = add word under cursor to good word in 'spellfile'
" zug = undo zg
" ]s = next misspelled word

" vim-dadbod fold result
autocmd FileType dbout setlocal nofoldenable

" autocmd FileType typescriptreact setlocal formatprg=prettier\ --parser\ typescript
" autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

"set clipboard^=unnamed,unnamedplus
syntax enable
set number
set relativenumber
set showcmd
set title
set ruler
set cursorline
set splitright splitbelow
set wrap
set scrolloff=5
set laststatus=2

set list
set listchars=tab:!·,trail:·

" completion
set complete+=kspell

" searching
set hls
set incsearch
set ignorecase
set smartcase

" undofile
set undodir=~/.vim/undodir
set undofile


" Color column
set colorcolumn=	"80,120
hi ColorColumn ctermbg=green
:call matchadd('ColorColumn', '\%81v', 100)

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on

function! NewBuffer () abort
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

Plug 'dstein64/vim-startuptime'

Plug 'junegunn/vim-plug'

" File
if has('nvim')
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'nvim-telescope/telescope-github.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/playground'

    Plug 'neovim/nvim-lspconfig'
else
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
endif
Plug 'preservim/nerdtree'

" PlantUML
Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'

" common
"Plug 'junegunn/vim-peekaboo'

" Vim HardTime
" Plug 'takac/vim-hardtime'

Plug 'justinmk/vim-sneak' " replace s with search
Plug 'tpope/vim-commentary' " gcc
Plug 'tpope/vim-obsession' " vim session
Plug 'tpope/vim-surround' " add/delete/change surround
" autocomplete
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
" Plug 'stephenway/postcss.vim'
" refactor
"Plug 'adoy/vim-php-refactoring-toolbox'
" git plugins
Plug 'tpope/vim-repeat' " repeat all plugins with .
Plug 'tpope/vim-fugitive' " Git
Plug 'rbong/vim-flog' " Git-Tree
Plug 'tpope/vim-rhubarb' " enable :GBrowse to github
Plug 'tpope/vim-dadbod' " Database
Plug 'kristijanhusak/vim-dadbod-ui' " Database-UI
Plug 'vim-scripts/ReplaceWithRegister' " replace with register - gr

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'} " only with node 16.X
" Plug 'neoclide/coc-html', {'do': 'npm install'} " only with 12.22.9
" Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
" CocInstall coc-html-css-support coc-tsserver coc-json coc-prettier coc-phpactor coc-phpls coc-tabnine coc-html

" Plug 'neoclide/coc-tabnine'
"
Plug 'jwalton512/vim-blade' " Blade-Template (Laravel 4+)

" % matches also on if/while
Plug 'andymass/vim-matchup'
" graphql
Plug 'jparise/vim-graphql'

" typescript
" Plug 'leafgarland/typescript-vim'
if has('nvim')
    " Training
    Plug 'tjdevries/train.nvim'
    Plug 'ThePrimeagen/vim-be-good'
    " Vim Script
    Plug 'folke/which-key.nvim'
    " google keep
    Plug 'stevearc/gkeep.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" wildermenu for :e and /
if has('nvim')
    function! UpdateRemotePlugins(...)
        " Needed to refresh runtime files
        let &rtp=&rtp
        UpdateRemotePlugins
    endfunction

    Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
    Plug 'gelguy/wilder.nvim'

    " To use Python remote plugin features in Vim, can be skipped
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" css-color
Plug 'ap/vim-css-color'

" multi-select
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" TODO: LEARN IT

" Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'

call plug#end()
" }}}

" Git {{{
if has("autocmd")
augroup fugitive
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
endif

command! GW :wa | :G add -A | :G commit -m "wip"
command! GP :execute ":G push origin " . fugitive#head() | :execute ":G branch --set-upstream-to=origin/" . fugitive#head() . " " . fugitive#head()
command! GPF :execute ":G push --force origin " . fugitive#head()
command! GA :G add -A | :G commit --amend --no-edit
command! GAP :execute "GA" | :GPF
command! GR :G fetch | :G rebase origin/master
command! GL :GlLog --invert-grep --grep Automated --grep "Phoenix"
command! -nargs=+ GN :silent execute ":G fetch | :G checkout origin/master | :G switch -c "<q-args>
command! GF :execute ":Flogsplit -all -date=short" | :execute "/HEAD -> " . fugitive#head() | :nohlsearch
" }}}


set statusline=
set statusline+=%<
set statusline+=%=
set statusline+=%f
set statusline+=\ %h " help-buffer
set statusline+=%m " modified-flag
set statusline+=%r " read-onlyflag
" set statusline+=%{FugitiveStatusline()}
set statusline+=%=
set statusline+=%{CodeStatsXp()}\ 
set statusline+=Session:\ %{ObsessionStatus('[active]','[paused]')}
set statusline+=\ %-14.(%l,%c%V%)\ %P
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

function! ReloadVimRc()
    " redraw!
    " echo $MYVIMRC . " reloaded"
endfunction
augroup vimrc
    au!
    " autocmd FileType vim
    au! BufWritePost $MYVIMRC silent source $MYVIMRC | call ReloadVimRc()
    au! BufWritePost .vimrc_project silent source $MYVIMRC | call ReloadVimRc()
    au! BufWritePost init.vim silent source $MYVIMRC | call ReloadVimRc()
    au! BufWritePost .vimrc silent source $MYVIMRC | call ReloadVimRc()
    au! BufWritePost ~/.vimrc_personal.vim silent source $MYVIMRC | call ReloadVimRc()
augroup END

" not waiting too long
set updatetime=1000

"{{{ Coc-Configs

highlight CocFloating ctermbg=black
highlight MatchParen ctermbg=240
highlight NormalFloat guibg=#222332


" let g:coc_start_at_startup = v:false

set shortmess+=c


function! ShowDocIfNoDiagnostic(args)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
    " call ShowDocIfNoDiagnostic()
    call timer_start(500, 'ShowDocIfNoDiagnostic')
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
" <silent> :CocRestart

source ~/.vim/abbreviate.vim

source ~/.vim/mappings.vim

" Personal-vimrc {{{
if filereadable(expand("~/.vimrc_personal.vim"))
    source ~/.vimrc_personal.vim
endif
" }}}
