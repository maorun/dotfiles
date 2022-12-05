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

require('gitsigns').setup {
    current_line_blame = true,
}

require'nvim-web-devicons'.setup {
    color_icons = true,
    default = true
}

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- File Browsing {{{
local treeApi = require("nvim-tree.api")
local function changeCwdToCurrentNode(node)
    treeApi.tree.change_root_to_node(node)
end

require("nvim-tree").setup({
    view = {
        adaptive_size = true, -- vergrößerung der Breite bei langen dateien
        relativenumber = true,
        number = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
                { key = "C", action = "changeCwdToCurrentNode", action_cb = changeCwdToCurrentNode}
            },
        },
    },
    diagnostics = {
        enable = true,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
    },
})
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})
-- }}}

-- gelguy/wilder.nvim
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

-- for vimrc_project
vim.cmd [[
        if exists("*PostVimRc")
        :call PostVimRc()
        endif
        ]]
