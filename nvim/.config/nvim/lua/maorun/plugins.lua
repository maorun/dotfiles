vim.cmd [[
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
]]

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/nvim/plugged')

Plug 'dstein64/vim-startuptime'

Plug 'junegunn/vim-plug'

-- File
    Plug 'lewis6991/impatient.nvim'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'nvim-telescope/telescope-github.nvim'
    Plug 'fannheyward/telescope-coc.nvim'
    Plug 'nvim-telescope/telescope-project.nvim'

Plug 'nvim-tree/nvim-web-devicons'
    Plug 'pwntester/octo.nvim'

    Plug('nvim-treesitter/nvim-treesitter', {[ 'do' ] = ':TSUpdate'})  -- We recommend updating the parsers on update
    -- Plug 'nvim-treesitter/playground'

    Plug 'neovim/nvim-lspconfig'

    Plug 'rafcamlet/nvim-luapad'

    Plug('iamcco/markdown-preview.nvim', { [ 'do' ]= 'cd app && npm install'  })

    -- Plug 'github/copilot.vim'

Plug 'nvim-tree/nvim-tree.lua'
-- Plug('preservim/nerdtree', { on= 'NERDTreeFind' })

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
-- git plugins
Plug 'tpope/vim-repeat' -- repeat all plugins with .
Plug 'tpope/vim-fugitive' -- Git
Plug 'rbong/vim-flog' -- Git-Tree
-- Plug 'AchmadFathoni/vim-flog' -- Git-Tree - Fork because of https://github.com/rbong/vim-flog/issues/77
Plug 'tpope/vim-rhubarb' -- enable :GBrowse to github
Plug 'tpope/vim-dadbod' -- Database
Plug 'kristijanhusak/vim-dadbod-ui' -- Database-UI
Plug 'vim-scripts/ReplaceWithRegister' -- replace with register - gr
Plug 'lewis6991/gitsigns.nvim' -- git-sign

Plug('neoclide/coc.nvim', {['branch']= 'release'})
-- Plug('rodrigore/coc-tailwind-intellisense', {'do': 'npm install'})  -- only with node 16.X
-- Plug 'neoclide/coc-html', {'do': 'npm install'} -- only with 12.22.9
-- Plug('iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'})
-- CocInstall coc-html-css-support coc-tsserver coc-json coc-prettier coc-phpactor coc-phpls coc-tabnine coc-html

Plug 'neoclide/coc-tabnine'

-- Plug 'jwalton512/vim-blade' -- Blade-Template (Laravel 4+)

-- % matches also on if/while
-- Plug 'andymass/vim-matchup'
-- graphql
-- Plug 'jparise/vim-graphql'

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
-- Plug 'ap/vim-css-color'

-- multi-select
-- Plug 'mg979/vim-visual-multi', {'branch': 'master'}
-- TODO: LEARN IT

-- Plug 'kana/vim-textobj-user'

-- aa - around argument
Plug 'wellle/targets.vim'

-- quick Filebrowsing
-- Plug 'ThePrimeagen/harpoon'

-- testing
Plug 'vim-test/vim-test'

Plug('maorun/snyk.nvim', { [ 'do' ]= 'npm install'  })
Plug('maorun/code-stats.nvim')

-- varnish-syntax highlighting
Plug 'fgsch/vim-varnish'

-- refactor
Plug "ThePrimeagen/refactoring.nvim"
vim.call('plug#end')

-- require('refactoring').setup({})

-- {{{ Coc-Configs
vim.cmd [[
    augroup Cursor
        autocmd!
    " autocmd CursorHold * silent call CocActionAsync('highlight')
    "    autocmd CursorHoldI * :call <SID>show_hover_doc()
    "    autocmd CursorHold * :call <SID>show_hover_doc()
    augroup END

    highlight CocFloating ctermbg=black
    highlight MatchParen ctermbg=240
    highlight NormalFloat guibg=#222332
    highlight CocMenuSel ctermbg=Grey guibg=DarkGrey

    function! ShowDocIfNoDiagnostic(args)
      if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
  "      silent call CocActionAsync('doHover')
      endif
    endfunction

    function! s:show_hover_doc()
        " call ShowDocIfNoDiagnostic()
        call timer_start(500, 'ShowDocIfNoDiagnostic')
    endfunction
]]
-- }}}
