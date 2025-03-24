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
                        return client.name ~= 'ts_ls'
                    end,
                })
            end

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                -- buf_set_keymap('i', '<C-Space>', '<c-x><c-o>', {noremap = true})

                wk.add({
                    { '<leader>ff',     Lsp_formatting,                                           desc = 'format with LSP', remap = false },
                    { '<leader>l',      group = 'LSP' },
                    { '<leader>l<C-k>', ':lua vim.lsp.buf.signature_help()<CR>',                  desc = 'Signature help',  remap = false },
                    { '<leader>lc',     ':lua vim.lsp.buf.code_action()<CR>',                     desc = 'code-action',     remap = false },
                    { '<leader>lf',     Lsp_formatting,                                           desc = 'format',          remap = false },
                    { '<leader>lg',     group = 'Goto' },
                    { '<leader>lgD',    ':lua vim.lsp.buf.declaration()<CR>',                     desc = 'Declaration',     remap = false },
                    { '<leader>lgd',    ':lua vim.lsp.buf.definition()<CR>',                      desc = 'Definition',      remap = false },
                    { '<leader>lgi',    ':lua vim.lsp.buf.implementation()<CR>',                  desc = 'Implementaion',   remap = false },
                    { '<leader>lgr',    ':lua require("telescope.builtin").lsp_references()<CR>', desc = 'References',      remap = false },
                    { '<leader>lgt',    ':lua vim.lsp.buf.type_definition()<CR>',                 desc = 'Type definition', remap = false },
                    { '<leader>lk',     ':lua vim.lsp.buf.hover()<CR>',                           desc = 'Hover',           remap = false },
                    { '<leader>lr',     ':lua vim.lsp.buf.rename()<CR>',                          desc = 'rename',          remap = false },
                })
                wk.add({
                    { 'g',  group = 'Goto' },
                    { 'gD', ':lua vim.lsp.buf.declaration()<CR>',                     desc = 'Declaration',     remap = false },
                    { 'gd', ':lua vim.lsp.buf.definition()<CR>',                      desc = 'Definition',      remap = false },
                    { 'gf', ':lua require("telescope.builtin").lsp_references()<CR>', desc = 'References',      remap = false },
                    { 'gy', ':lua vim.lsp.buf.type_definition()<CR>',                 desc = 'Type definition', remap = false },
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
                { '<leader>lK', ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<cr>', desc = 'open_float', },
                { '<leader>lq', ':lua vim.diagnostic.setloclist()<cr>',                                   desc = 'show diagnostics', },
            })
            wk.add({
                { 'g',  group = 'Goto' },
                { 'g[', ':lua vim.diagnostic.goto_prev()<CR>zz', desc = 'next diagnostic', remap = false },
                { 'g]', ':lua vim.diagnostic.goto_next()<CR>zz', desc = 'prev diagnostic', remap = false },
            })

            local servers = {
                'lua_ls',
                'ts_ls',
                'pyright',
                -- 'graphql',
                -- 'phpactor',
                'sqlls',
                'eslint',
            }

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
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = vim.api.nvim_create_augroup('format', {}),
                            buffer = bufnr,
                            callback = function(event)
                                local ts_clients = vim.lsp.get_clients({
                                    name = 'ts_ls',
                                    bufnr = event.buf,
                                })

                                if (ts_clients) then
                                    ts_clients[1].request('workspace/executeCommand', {
                                        command = '_typescript.organizeImports',
                                        arguments = { vim.fn.expand('%:p') }
                                    })
                                end
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
            ---@diagnostic disable-next-line: duplicate-set-field
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                ---@diagnostic disable-next-line: inject-field
                opts.border = opts.border or border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            -- Show source in diagnostics
            vim.diagnostic.config({
                virtual_text = {
                    source = true
                },
                float = {
                    source = true
                },
            })
        end,
    }
}
