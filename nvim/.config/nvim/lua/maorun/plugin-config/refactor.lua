require("telescope").load_extension("refactoring")
vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
)
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>ref", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>rff",
    [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>reb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
    { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("n", "<leader>rebf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
    { noremap = true, silent = true, expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })

require('refactoring').setup({})
local wk = require("which-key")

wk.register({
    r = {
        name = "Refactor",
        d = {
            name = "debugs",
            c = { ":lua require('refactoring').debug.cleanup({})<CR>", "delete debugs", { noremap = true } },
            p = { ":lua require('refactoring').debug.printf({below = false})<CR>", "add print-statement",
                { noremap = true } },
            v = { ":lua require('refactoring').debug.print_var({ normal = true })<CR>", "print variable",
                { noremap = true } },
        }

    }
}, { prefix = '<leader>' })
wk.register({
    r = {
        name = "Refactor",
        d = {
            name = "debugs",
            v = { ":lua require('refactoring').debug.print_var({})<CR>", "print visual text", { noremap = true } },
        }

    }
}, { prefix = '<leader>', mode = "v" })
