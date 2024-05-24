return {
    {
        'ThePrimeagen/refactoring.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        },
        init = function()
            require("telescope").load_extension("refactoring")

            vim.keymap.set(
                { "n", "x" },
                "<leader>rr",
                function() require('telescope').extensions.refactoring.refactors() end,
                { noremap = true }
            )

            require('refactoring').setup({
                print_var_statements = {
                    typescriptreact = {
                        "// %s \nconsole.dir(%s, { depth: 6 });",
                    },
                    typescript = {
                        "// %s \nconsole.dir(%s, { depth: 6 });",
                    },
                }
            })
            local wk = require("which-key")

            wk.register({
                d = {
                    c = { ":lua require('refactoring').debug.cleanup({})<CR>", "delete debugs", { noremap = true } },
                    P = { ":lua require('refactoring').debug.printf({below = false})<CR>", "add print-statement",
                        { noremap = true } },
                    p = { ":lua require('refactoring').debug.printf({below = true})<CR>", "add print-statement",
                        { noremap = true } },
                },
                r = {
                    name = "Refactor",
                    d = {
                        name = "debugs",
                        c = { ":lua require('refactoring').debug.cleanup({})<CR>", "delete debugs", { noremap = true } },
                        P = { ":lua require('refactoring').debug.printf({below = false})<CR>", "add print-statement",
                            { noremap = true } },
                        p = { ":lua require('refactoring').debug.printf({below = true})<CR>", "add print-statement",
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
        end,
    }
}
