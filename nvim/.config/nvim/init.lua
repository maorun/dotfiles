vim.g.mapleader = ' '
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd[[
    tnoremap <Esc> <C-\><C-n>
    highlight MatchParen ctermbg=240
    highlight NormalFloat guibg=#222332
]]

vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath

    function! ShowCmdInNewBuffer (cmd) abort "{{{
        let res = system(a:cmd)
        lua newBuffer()
        " :call NewBuffer()
        silent put=res
        :normal gg
        silent :normal dd
    endfunction "}}}

    " Hardtime
    let g:hardtime_default_on = 0
    let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
]]

vim.cmd("let $PATH = '~/.nvm/versions/node/v17.4.0/bin:' . $PATH")

require 'maorun.packer'
require 'maorun'
require 'time'.setup()

vim.cmd [[
    augroup luaReload
        autocmd!
        autocmd! BufWritePost */nvim/**.lua so %
        au! BufWritePost $MYVIMRC silent source $MYVIMRC
        au! BufWritePost .vimrc_project silent source $MYVIMRC
        au! BufWritePost .vimrc silent source $MYVIMRC
        au! BufWritePost ~/.vimrc_personal.vim silent source $MYVIMRC
    augroup END
]]
