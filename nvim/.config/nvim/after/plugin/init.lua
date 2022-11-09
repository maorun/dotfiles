-- if file .vimrc_project exists in the project directory, source it
if vim.fn.filereadable(vim.fn.expand(".vimrc_project")) == 1 then
    vim.cmd("source .vimrc_project")
end
if vim.fn.filereadable(vim.fn.expand(".vimrc_project.lua")) == 1 then
    vim.cmd("source .vimrc_project.lua")
end

-- maorun/snyk
require('maorun.snyk').setup()
require('maorun.code-stats').setup()

require('which-key').setup {}

require('maorun.telescope').init()

require('gitsigns').setup {
    current_line_blame = true,
}

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

-- for vimrc_project
vim.cmd [[
        if exists("*PostVimRc")
        :call PostVimRc()
        endif
        ]]
