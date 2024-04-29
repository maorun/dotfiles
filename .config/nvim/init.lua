vim.cmd("autocmd BufRead,BufNewFile *.md,*.markdown,*.mdx setlocal filetype=markdown")

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ' '
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd [[colorscheme default]]

vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
]]

vim.cmd [[
    command! WipeReg for i in range(97, 122) | silent! call setreg(nr2char(i), []) | endfor | for i in range(65, 90) | silent! call setreg(nr2char(i), []) | endfor
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath

    function! ShowCmdInNewBuffer (cmd) abort "{{{
        let res = system(a:cmd)
        lua NewBuffer()
        " :call NewBuffer()
        silent put=res
        :normal gg
        silent :normal dd
    endfunction "}}}

    " Hardtime
    let g:hardtime_default_on = 0
    let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
]]

-- vim.cmd("let $PATH = '~/.nvm/versions/node/v17.4.0/bin:' . $PATH")

vim.loader.enable()

require 'maorun.lazy'
require 'maorun'

vim.cmd [[
    augroup luaReload
        autocmd!
        autocmd! BufWritePost */nvim/**(!.spec).lua so %
        " au! BufWritePost $MYVIMRC silent source $MYVIMRC
        " au! BufWritePost .vimrc_project silent source $MYVIMRC
        " au! BufWritePost .vimrc silent source $MYVIMRC
        " au! BufWritePost ~/.vimrc_personal.vim silent source $MYVIMRC
    augroup END
]]
