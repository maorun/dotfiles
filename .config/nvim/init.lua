vim.cmd('autocmd BufRead,BufNewFile *.md,*.markdown,*.mdx setlocal filetype=markdown')

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd [[colorscheme default]]

vim.cmd [[
    tnoremap <Esc> <C-\><C-n>
]]

vim.cmd [[
    command! WipeReg for i in range(97, 122) | silent! call setreg(nr2char(i), []) | endfor | for i in range(65, 90) | silent! call setreg(nr2char(i), []) | endfor | for i in range(65, 90) | silent! call setreg(nr2char(i), []) | endfor | for i in range(65, 90) | silent! call setreg(nr2char(i), []) | endfor
    let &packpath = &runtimepath

    " Hardtime
    let g:hardtime_default_on = 0
    let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
]]

vim.loader.enable()

require 'maorun.lazy'
require 'maorun'

vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('luaReload', {}),
    pattern = '*.lua',
    callback = function()
        local file = vim.fn.expand('<afile>') -- Get the full path of the written file

        -- Exclude files ending with .spec.lua
        if not file:match('%.spec%.lua$') then
            vim.cmd('source ' .. file) -- Source the Lua file
        end
    end,
})
