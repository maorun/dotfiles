return {
    on_init = function(client)
        local signcolumnAuGroup = vim.api.nvim_create_augroup('signcolumn', {})
        vim.api.nvim_create_autocmd('FileType', {
            group = signcolumnAuGroup,
            pattern = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
            command = 'setlocal signcolumn=yes',
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('ts_ls_au', {}),
            callback = function(args)
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = vim.api.nvim_create_augroup('ts_ls_au', { clear = false }),
                    buffer = args.buf,
                    callback = function()
                        local clientAttach = assert(vim.lsp.get_client_by_id(args.data.client_id))
                        if (clientAttach.name == 'ts_ls') then
                            vim.lsp.buf.code_action({
                                apply = true,
                                context = {
                                    diagnostics = {},
                                    only = {
                                        ---@diagnostic disable-next-line: assign-type-mismatch
                                        "source.removeUnusedImports.ts"
                                    }
                                }
                            })
                        end
                    end,
                })
            end
        })

        local wk = require('which-key')
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
    end,
}
