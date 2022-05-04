vim.cmd [[
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath

    function! ShowCmdInNewBuffer (cmd) abort "{{{
        let res = system(a:cmd)
        :call NewBuffer()
        silent put=res
        :normal gg
        silent :normal dd
    endfunction "}}}

    " Hardtime
    let g:hardtime_default_on = 0
    let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
]]

vim.cmd("let $PATH = '~/.nvm/versions/node/v17.4.0/bin:' . $PATH")

require 'maorun.plugins'
vim.defer_fn(function()
    if vim.fn.filereadable(vim.fn.expand("~/.vimrc_personal.vim")) == 1 then
        vim.cmd("source ~/.vimrc_personal.vim")
    end
    -- if file .vimrc_project exists in the project directory, source it
    if vim.fn.filereadable(vim.fn.expand(".vimrc_project")) == 1 then
        vim.cmd("source .vimrc_project")
    end
    if vim.fn.filereadable(vim.fn.expand(".vimrc_project.lua")) == 1 then
        vim.cmd("source .vimrc_project.lua")
    end

    require('which-key').setup {}
    require 'maorun.mappings'

    require 'maorun.treesitter'
    require('maorun.appleScript').init()

    require('maorun.telescope').init()
    require('maorun.lsp')
    require('maorun.git')

    require'nvim-web-devicons'.setup {
        default = true
    }

    -- gelguy/wilder.nvim
    local wilder = require('wilder')
    wilder.setup({modes = {':', '/', '?'}})
    wilder.set_option('pipeline', {
        wilder.branch(
            wilder.cmdline_pipeline({
                language = 'python',
                fuzzy = 2,
            }),
            wilder.python_search_pipeline({
                pattern = wilder.python_fuzzy_pattern({
                    start_at_boundary = 0
                }),
                sorter = wilder.python_difflib_sorter(),
                engine = 're',
            })
        )
    })
    wilder.set_option('renderer', wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        separator = ' · ',
        left = {' ', wilder.wildmenu_spinner(), ' '},
        right = {' ', wilder.wildmenu_index()},
    }))

    require 'maorun.options'

    -- for vimrc_project
    vim.cmd [[
        if exists("*PostVimRc")
            :call PostVimRc()
        endif
    ]]


end, 0)

vim.cmd [[
    augroup lua reload
        autocmd!
        autocmd! BufWritePost */nvim/**.lua so %
        au! BufWritePost $MYVIMRC silent source $MYVIMRC
        au! BufWritePost .vimrc_project silent source $MYVIMRC
        au! BufWritePost .vimrc silent source $MYVIMRC
        au! BufWritePost ~/.vimrc_personal.vim silent source $MYVIMRC
    augroup END
]]
