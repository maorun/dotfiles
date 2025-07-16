return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'folke/which-key.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'zbirenbaum/copilot-cmp',
            'tzachar/cmp-tabnine',
            'hrsh7th/cmp-nvim-lsp',
            'mattn/efm-langserver',
            'folke/neodev.nvim', -- lsp for neovim
        },
        event = 'VimEnter',
        config = function()
            local wk = require('which-key')

            require('neodev').setup({
            })

            local nvim_lsp = require('lspconfig')

            -- format without tsserver
            function Lsp_formatting()
                vim.lsp.buf.format({
                    async = true,
                    filter = function(client)
                        -- disable tsserver formating
                        return client.name ~= 'ts_ls'
                    end,
                })
            end

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                -- buf_set_keymap('i', '<C-Space>', '<c-x><c-o>', {noremap = true})

                wk.add({
                    { '<leader>ff', Lsp_formatting, desc = 'format with LSP', },
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
                if (client.name == 'ts_ls') then
                    wk.add({
                        {
                            '<leader>o',
                            function()
                                client.request('workspace/executeCommand', {
                                    command = '_typescript.organizeImports',
                                    arguments = { vim.fn.expand('%:p') }
                                })
                            end,
                            desc = 'Organize imports'
                        },
                    })
                end
            end

            -- Diagnostics mapping (should also available without LSP)
            wk.add({
                { '<leader>l',  group = 'LSP' },
                { '<leader>lq', ':lua vim.diagnostic.setloclist()<cr>', desc = 'show diagnostics', },
            })

            local servers = {
                'lua_ls',
                'ts_ls',
                'pyright',
                -- 'graphql',
                -- 'phpactor',
                'sqlls',
                'eslint',
                'rust_analyzer',
            }
            vim.lsp.enable('oxlint')

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            for _, lsp in ipairs(servers) do
                nvim_lsp[lsp].setup {
                    settings = {
                        Lua = {
                            -- Do not send telemetry data containing a randomized but unique identifier
                            telemetry = {
                                enable = false,
                            },
                            format = {
                                defaultConfig = {
                                    column_width = 100,
                                    indent_type = "Spaces",
                                    indent_width = 4,
                                    quote_style = "AutoPreferSingle",
                                    call_parentheses = "Always",
                                }
                            },
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = { 'vim' },
                            },
                            completion = {
                                callSnippet = 'Replace'
                            },
                        },
                    },
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = vim.api.nvim_create_augroup('format', {}),
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    async = false,
                                    filter = function(formatClient)
                                        -- disable tsserver formating
                                        return formatClient.name ~= 'ts_ls'
                                    end,
                                })
                            end
                        })
                        if (lsp == 'eslint') then
                            vim.api.nvim_create_autocmd('BufWritePre', {
                                buffer = bufnr,
                                command = 'EslintFixAll',
                            })
                        end
                    end,
                    capabilities = capabilities,
                    flags = {
                        debounce_text_changes = 150,
                    }
                }
            end

            local formatEfm = {
                formatCommand =
                "prettier --stdin-filepath '${INPUT}' ${--range-start:charStart} ${--range-end:charEnd}",
                formatCanRange = true,
                formatStdin = true,
                rootMarkers = {
                    '.prettierrc',
                    '.prettierrc.json',
                    '.prettierrc.js',
                    '.prettierrc.yml',
                    '.prettierrc.yaml',
                    '.prettierrc.json5',
                    '.prettierrc.mjs',
                    '.prettierrc.cjs',
                    '.prettierrc.toml',
                    'prettier.config.js',
                    'prettier.config.cjs',
                    'prettier.config.mjs',
                },
            }

            nvim_lsp['efm'].setup {
                filetypes = { 'json', 'svg', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'html' },
                init_options = {
                    documentFormatting = true,
                    codeAction = false,
                },
                root_dir = nvim_lsp.util.root_pattern('.prettierrc.json'),
                settings = {
                    rootMarkers = formatEfm.rootMarkers,
                    logLevel = 5,
                    languages = {
                        json = { formatEfm, },
                        svg = { formatEfm, },
                        html = { formatEfm, },
                        typescript = { formatEfm, },
                        javascript = { formatEfm, },
                        typescriptreact = { formatEfm, },
                        javascriptreact = { formatEfm, },
                    },
                },
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                end,
                capabilities = capabilities,
            }

            nvim_lsp['tailwindcss'].setup {
                settings = {
                    classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
                    classFunctions = { 'tw', 'clsx', 'classNames' },
                    -- https://github.com/tailwindlabs/tailwindcss-intellisense?tab=readme-ov-file#extension-settings
                    tailwindCSS = {
                        classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
                        classFunctions = { 'tw', 'clsx', 'classNames' },
                        showPixelEquivalents = false,
                        experimental = {
                            configFile = {
                                ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/techbook/tailwind.css'] = '**/Techbook/**',
                                ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/bildkaufberater/tailwind.css'] = '**/BildKaufberater/**',
                                ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/bild/tailwind.css'] = '**/Bild/**',
                                ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/computerbild/tailwind.css'] = '**/ComputerBild/**',
                                ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/autobild/tailwind.css'] = '**/AutoBild/**',
                                ['/Users/mdriemel/repos/ac-steam/packages/backend/app/tailwind.css'] = '**/backend/**',
                            }
                        }
                    }
                },
                root_dir = function(fname)
                    if (string.find(fname, '/Users/mdriemel/repos/ac%-steam')) then
                        return '/Users/mdriemel/repos/ac-steam/'
                    end

                    local rootPath = nvim_lsp.util.root_pattern('tailwind.config.js',
                            'tailwind.config.cjs',
                            'tailwind.config.mjs', 'tailwind.config.ts',
                            'tailwind.css'
                        )(
                            fname
                        ) or nvim_lsp.util.find_package_json_ancestor(fname) or
                        nvim_lsp.util.find_node_modules_ancestor(fname) or
                        nvim_lsp.util.find_git_ancestor(
                            fname
                        )

                    return rootPath
                end,
                on_attach = on_attach,
                capabilities = capabilities,
                flags = {
                    debounce_text_changes = 150,
                }
            }

            local signcolumnAuGroup = vim.api.nvim_create_augroup('signcolumn', {})
            vim.api.nvim_create_autocmd('FileType', {
                group = signcolumnAuGroup,
                pattern = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
                command = 'setlocal signcolumn=yes',
            })

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
