return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'folke/which-key.nvim',
            'hrsh7th/nvim-cmp',
            'mattn/efm-langserver',
        },
        event = { 'BufReadPre', 'BufNewFile' },
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

            -- TypeScript 7 ships a native binary and provides no `tsserver.js`.
            -- `ts_ls` needs `tsserver.js`, so route such projects to `tsc --lsp`.
            -- Classic TypeScript installs the executables `tsc` and `tsserver`.
            -- TypeScript 7 installs only `tsc`.
            ---@param bufnr integer
            ---@return 'ts_ls'|'tsc'|nil
            local function typescript_server(bufnr)
                local fname = vim.api.nvim_buf_get_name(bufnr)
                -- vim.fs.parents yields the nearest directory first.
                -- The nearest installation decides, as in a package manager.
                if fname ~= '' then
                    for dir in vim.fs.parents(fname) do
                        local lib = vim.fs.joinpath(dir, 'node_modules', 'typescript', 'lib')
                        if vim.uv.fs_stat(lib) then
                            if vim.uv.fs_stat(vim.fs.joinpath(lib, 'tsserver.js')) then
                                return 'ts_ls'
                            end
                            return 'tsc'
                        end
                    end
                end
                -- The project holds no TypeScript. Use the global installation.
                if vim.fn.executable('tsserver') == 1 then
                    return 'ts_ls'
                end
                if vim.fn.executable('tsc') == 1 then
                    return 'tsc'
                end
            end

            local ts_ls_root_dir = vim.lsp.config.ts_ls.root_dir
            vim.lsp.config('ts_ls', {
                root_dir = function(bufnr, on_dir)
                    -- Skip activation: do not call on_dir.
                    if typescript_server(bufnr) ~= 'ts_ls' or not ts_ls_root_dir then
                        return
                    end
                    return ts_ls_root_dir(bufnr, on_dir)
                end,
            })

            local tsc_root_dir = vim.lsp.config.tsc.root_dir
            vim.lsp.config('tsc', {
                root_dir = function(bufnr, on_dir)
                    -- Skip activation: do not call on_dir.
                    if typescript_server(bufnr) ~= 'tsc' or not tsc_root_dir then
                        return
                    end
                    return tsc_root_dir(bufnr, on_dir)
                end,
            })

            vim.lsp.enable({ 'prettier', 'eslint', 'oxlint', 'ts_ls', 'tsc', })
            -- vim.lsp.inline_completion.enable()

            local base_root_dir = vim.lsp.config.tailwindcss.root_dir
            local ac_steam_root = vim.fs.joinpath(vim.env.HOME, 'repos', 'ac-steam')
            -- Custom root_dir for tailwindcss to work in monorepo (couldn't set in lsp/tailwindcss.lua)
            vim.lsp.config('tailwindcss', {
                -- Neovim calls root_dir with the buffer number, not the file name.
                root_dir = function(bufnr, on_dir)
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    if fname ~= '' then
                        if vim.fs.root(fname, 'tailwind.css') then
                            return on_dir(vim.fn.getcwd())
                        end
                        if vim.startswith(vim.fs.normalize(fname), ac_steam_root .. '/') then
                            return on_dir(ac_steam_root)
                        end
                    end
                    if base_root_dir then
                        return base_root_dir(bufnr, on_dir)
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
