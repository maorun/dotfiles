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
        init = function()
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
                        return client.name ~= 'tsserver'
                    end,
                })
            end

            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                -- buf_set_keymap('i', '<C-Space>', '<c-x><c-o>', {noremap = true})

                wk.register({
                    l = {
                        name = 'LSP',
                        g = {
                            name = 'Goto',
                            D = { ':lua vim.lsp.buf.declaration()<CR>', 'Declaration', noremap = true },
                            d = { ':lua vim.lsp.buf.definition()<CR>', 'Definition', noremap = true },
                            i = { ':lua vim.lsp.buf.implementation()<CR>', 'Implementaion', noremap = true },
                            r = { ':lua require("telescope.builtin").lsp_references()<CR>', 'References', noremap = true },
                            t = { ':lua vim.lsp.buf.type_definition()<CR>', 'Type definition', noremap = true },
                        },
                        k = { ':lua vim.lsp.buf.hover()<CR>', 'Hover', noremap = true },
                        ['<C-k>'] = { ':lua vim.lsp.buf.signature_help()<CR>', 'Signature help', noremap = true },
                        r = { ':lua vim.lsp.buf.rename()<CR>', 'rename', noremap = true },
                        c = { ':lua vim.lsp.buf.code_action()<CR>', 'code-action', noremap = true },
                        f = { Lsp_formatting, 'format', noremap = true },
                    },
                    ff = { Lsp_formatting, 'format with LSP', noremap = true },
                }, { silent = true, prefix = '<leader>' })
                wk.register({
                    g = {
                        name = 'Goto',
                        D = { ':lua vim.lsp.buf.declaration()<CR>', 'Declaration', noremap = true },
                        d = { ':lua vim.lsp.buf.definition()<CR>', 'Definition', noremap = true },
                        f = { ':lua require("telescope.builtin").lsp_references()<CR>', 'References', noremap = true },
                        y = { ':lua vim.lsp.buf.type_definition()<CR>', 'Type definition', noremap = true },
                    },
                }, { silent = true })
            end
            -- Diagnostics mapping (should also available without LSP)
            wk.register({
                l = {
                    name = 'LSP',
                    K = { ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<cr>', 'open_float', noremap = true },
                    q = { ':lua vim.diagnostic.setloclist()<cr>', 'show diagnostics', noremap = true },
                },
                o = { ':lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<cr>', 'Organize imports', noremap = true },
            }, { silent = true, prefix = '<leader>' })
            wk.register({
                g = {
                    name = 'Goto',
                    ['['] = { ':lua vim.diagnostic.goto_prev()<CR>', 'next diagnostic', noremap = true },
                    [']'] = { ':lua vim.diagnostic.goto_next()<CR>', 'prev diagnostic', noremap = true },
                },
            }, { silent = true })

            local servers = {
                'lua_ls',
                'tsserver',
                'pyright',
                -- 'graphql',
                'phpactor', 'sqlls', 'eslint' }

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
                                    indent_style = 'space',
                                    indent_size = '4',
                                    -- trailing_table_separator = 'always',
                                    quote_style = 'single',
                                    call_arg_parentheses = 'keep',
                                    max_line_length = '100'
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
                "prettier --stdin --stdin-filepath '${INPUT}' ${--range-start:charStart} ${--range-end:charEnd}",
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
                filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'html' },
                init_options = { documentFormatting = true },
                settings = {
                    rootMarkers = { '.git/' },
                    logLevel = 5,
                    languages = {
                        html = { formatEfm, },
                        typescript = { formatEfm, },
                        javascript = { formatEfm, },
                        typescriptreact = { formatEfm, },
                        javascriptreact = { formatEfm, },
                    },
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            nvim_lsp['tailwindcss'].setup {
                settings = {
                    -- https://github.com/tailwindlabs/tailwindcss-intellisense?tab=readme-ov-file#extension-settings
                    tailwindCSS = {
                        showPixelEquivalents = false,
                        -- experimental = {
                        --     configFile = {
                        --     [ "./packages/backend/tailwind.config.js" ] = "packages/backend/**",
                        --     [ "./packages/shared/tailwind.config.js" ] = "packages/**"
                        --     }
                        -- },
                    }
                },
                root_dir = function(fname)
                    if (string.find(fname, '/Users/mdriemel/repos/ac%-steam/packages/backend')) then
                        return '/Users/mdriemel/repos/ac-steam/packages/backend/'
                    else
                        if (string.find(fname, '/Users/mdriemel/repos/ac%-steam')) then
                            return '/Users/mdriemel/repos/'
                        end
                    end

                    local rootPath = nvim_lsp.util.root_pattern('tailwind.config.js',
                            'tailwind.config.cjs',
                            'tailwind.config.mjs', 'tailwind.config.ts'
                        )(
                            fname
                        ) or
                        nvim_lsp.util.root_pattern('postcss.config.js', 'postcss.config.cjs',
                            'postcss.config.mjs',
                            'postcss.config.ts')(
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

            local border = {
                { '╔', 'LspFloatWinBorder' },
                { '═', 'LspFloatWinBorder' },
                { '╗', 'LspFloatWinBorder' },
                { '║', 'LspFloatWinBorder' },
                { '╝', 'LspFloatWinBorder' },
                { '═', 'LspFloatWinBorder' },
                { '╚', 'LspFloatWinBorder' },
                { '║', 'LspFloatWinBorder' },
            }

            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            -- Show source in diagnostics
            vim.diagnostic.config({
                virtual_text = {
                    source = 'always',
                },
                float = {
                    source = 'always',
                },
            })
        end,
    }
}
