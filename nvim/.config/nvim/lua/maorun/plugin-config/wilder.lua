vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = vim.api.nvim_create_augroup('Wilder', {}),
    once = true,
    pattern = '*',
    callback = function()
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
    end,
})

