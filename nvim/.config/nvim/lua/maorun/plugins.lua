vim.cmd [[
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
]]

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/nvim/plugged')

Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

Plug 'dstein64/vim-startuptime'

-- Plug 'junegunn/vim-plug'

-- File
    Plug 'lewis6991/impatient.nvim'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'nvim-telescope/telescope-github.nvim'
    Plug 'fannheyward/telescope-coc.nvim'

    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'pwntester/octo.nvim'

    Plug('nvim-treesitter/nvim-treesitter', {[ 'do' ] = ':TSUpdate'})  -- We recommend updating the parsers on update
    -- Plug 'nvim-treesitter/playground'

    Plug 'neovim/nvim-lspconfig'

    Plug 'rafcamlet/nvim-luapad'

    Plug('iamcco/markdown-preview.nvim', { [ 'do' ]= 'cd app && npm install'  })

    Plug 'github/copilot.vim'

Plug('preservim/nerdtree', { on= 'NERDTreeFind' })

-- common
-- Plug 'junegunn/vim-peekaboo'

-- Vim HardTime
-- Plug 'takac/vim-hardtime'

Plug 'justinmk/vim-sneak' -- replace s with search
Plug 'tpope/vim-commentary' -- gcc
Plug 'tpope/vim-obsession' -- vim session
Plug 'tpope/vim-surround' -- add/delete/change surround
-- autocomplete
Plug('phpactor/phpactor', {[ 'for' ]= 'php', [ 'tag' ]= '*', [ 'do' ]= 'composer install --no-dev -o'})
-- Plug 'stephenway/postcss.vim'
-- refactor
-- lug 'adoy/vim-php-refactoring-toolbox'
-- git plugins
Plug 'tpope/vim-repeat' -- repeat all plugins with .
Plug 'tpope/vim-fugitive' -- Git
Plug 'rbong/vim-flog' -- Git-Tree
Plug 'tpope/vim-rhubarb' -- enable :GBrowse to github
Plug 'tpope/vim-dadbod' -- Database
Plug 'kristijanhusak/vim-dadbod-ui' -- Database-UI
Plug 'vim-scripts/ReplaceWithRegister' -- replace with register - gr

Plug('neoclide/coc.nvim', {['branch']= 'release'})
-- Plug('rodrigore/coc-tailwind-intellisense', {'do': 'npm install'})  -- only with node 16.X
-- Plug 'neoclide/coc-html', {'do': 'npm install'} -- only with 12.22.9
-- Plug('iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'})
-- CocInstall coc-html-css-support coc-tsserver coc-json coc-prettier coc-phpactor coc-phpls coc-tabnine coc-html

-- Plug 'neoclide/coc-tabnine'

Plug 'jwalton512/vim-blade' -- Blade-Template (Laravel 4+)

-- % matches also on if/while
Plug 'andymass/vim-matchup'
-- graphql
Plug 'jparise/vim-graphql'

-- typescript
-- Plug 'leafgarland/typescript-vim'
    -- Training
    -- Plug 'tjdevries/train.nvim'
    Plug('ThePrimeagen/vim-be-good', { on= 'VimBeGood' })
    -- Vim Script
    Plug 'folke/which-key.nvim'
    -- google keep
    Plug('stevearc/gkeep.nvim', { [ 'do' ]= ':UpdateRemotePlugins' })

-- wildermenu for :e and /
    -- function! UpdateRemotePlugins(...)
    -- end
Plug('gelguy/wilder.nvim', { [ 'do' ] = function()
    -- Needed to refresh runtime files
    vim.cmd "let &rtp=&rtp"
    vim.call('UpdateRemotePlugins')
end})

-- css-color
Plug 'ap/vim-css-color'

-- multi-select
-- Plug 'mg979/vim-visual-multi', {'branch': 'master'}
-- TODO: LEARN IT

-- Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'

-- quick Filebrowsing
Plug 'ThePrimeagen/harpoon'

vim.call('plug#end')

-- File Browsing {{{
vim.cmd [[
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
]]
-- }}}

-- {{{ Coc-Configs
vim.cmd [[
    highlight CocFloating ctermbg=black
    highlight MatchParen ctermbg=240
    highlight NormalFloat guibg=#222332

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
]]
-- }}}
