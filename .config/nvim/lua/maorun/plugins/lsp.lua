return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'folke/which-key.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'zbirenbaum/copilot-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'mattn/efm-langserver',
        },
        event = 'VimEnter',
        config = function()
            local wk = require('which-key')

            -- Diagnostics mapping (should also available without LSP)
            wk.add({
                { '<leader>l',  group = 'LSP' },
                { '<leader>lq', ':lua vim.diagnostic.setloclist()<cr>', desc = 'show diagnostics', },
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.lsp.config('*', {
                capabilities = capabilities,
                on_attach = function()
                    wk.add({
                        {
                            '<leader>ff',
                            function()
                                vim.lsp.buf.format({
                                    async = true,
                                })
                            end,
                            desc = 'format with LSP',
                        },
                        {
                            'K',
                            function()
                                vim.lsp.buf.hover({
                                    border = {
                                        { '╔', 'LspFloatWinBorder' },
                                        { '═', 'LspFloatWinBorder' },
                                        { '╗', 'LspFloatWinBorder' },
                                        { '║', 'LspFloatWinBorder' },
                                        { '╝', 'LspFloatWinBorder' },
                                        { '═', 'LspFloatWinBorder' },
                                        { '╚', 'LspFloatWinBorder' },
                                        { '║', 'LspFloatWinBorder' },
                                    },
                                })
                            end,
                            desc = 'LSP - hover with border'
                        },
                    })

                    wk.add({
                        { 'grr', ':lua require("telescope.builtin").lsp_references()<CR>', desc = 'References' },
                    })
                end,
                flags = {
                    debounce_text_changes = 150,
                },
            })

            vim.lsp.enable('lua_ls')

            vim.lsp.enable({ 'prettier', 'eslint', 'oxlint', 'ts_ls', })
            -- vim.lsp.inline_completion.enable()

            local base_root_dir = vim.lsp.config.tailwindcss.root_dir
            -- Custom root_dir for tailwindcss to work in monorepo (couldn't set in lsp/tailwindcss.lua)
            vim.lsp.config('tailwindcss', {
                root_dir = function(fname, on_dir)
                    if vim.fs.root(fname, 'tailwind.css') then
                        return on_dir(vim.fn.getcwd())
                    end
                    if (string.find(fname, '/Users/mdriemel/repos/ac%-steam')) then
                        return '/Users/mdriemel/repos/ac-steam/'
                    end
                    if base_root_dir then
                        return base_root_dir(fname, on_dir)
                    end
                end,
            })
            vim.lsp.enable('tailwindcss')

            -- Show source in diagnostics
            vim.diagnostic.config({
                virtual_lines = {
                    current_line = true,
                    format = function(diagnostic)
                        local source = diagnostic.source
                        if source and source ~= 'null' then
                            return string.format('[%s]: %s', source, diagnostic.message)
                        else
                            return diagnostic.message
                        end
                    end
                },
                underline = true,
                virtual_text = {
                    format = function()
                        return '!'
                    end,
                },
                signs = false,
            })
        end,
    }
}
