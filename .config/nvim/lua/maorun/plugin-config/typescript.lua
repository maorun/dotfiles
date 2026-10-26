-- Shared editor integration for the TypeScript language servers.
-- `ts_ls` advertises the suffixed kinds, for example `source.organizeImports.ts`.
-- The native `tsc` server advertises the plain kinds, for example `source.organizeImports`.
local M = {}

--- Returns the code action kind that the client advertises for one prefix.
---@param client vim.lsp.Client
---@param prefix string
---@return string?
local function supported_kind(client, prefix)
    local provider = client.server_capabilities.codeActionProvider
    local kinds = type(provider) == 'table' and provider.codeActionKinds or nil
    for _, kind in ipairs(kinds or {}) do
        if kind == prefix or vim.startswith(kind, prefix .. '.') then
            return kind
        end
    end
end

--- Applies one code action kind to the current buffer.
---@param kind string
local function apply_kind(kind)
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            diagnostics = {},
            ---@diagnostic disable-next-line: assign-type-mismatch
            only = { kind },
        },
    })
end

-- The sign column stays constant for each TypeScript buffer.
-- Register it once, independent of the attached language server.
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('signcolumn', {}),
    pattern = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
    command = 'setlocal signcolumn=yes',
})

--- Sets up the shared TypeScript integration for one language server client.
---@param client vim.lsp.Client
function M.setup(client)
    local group = vim.api.nvim_create_augroup('maorun_typescript_' .. client.name, { clear = true })
    local remove_unused_imports = supported_kind(client, 'source.removeUnusedImports')

    if remove_unused_imports then
        vim.api.nvim_create_autocmd('LspAttach', {
            group = group,
            callback = function(args)
                if args.data.client_id ~= client.id then
                    return
                end
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = group,
                    buffer = args.buf,
                    callback = function()
                        apply_kind(remove_unused_imports)
                    end,
                })
            end,
        })
    end

    local organize_imports = supported_kind(client, 'source.organizeImports')

    if organize_imports then
        require('which-key').add({
            {
                '<leader>o',
                function()
                    apply_kind(organize_imports)
                end,
                desc = 'Organize imports',
            },
        })
    end
end

return M
