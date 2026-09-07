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

return {
    cmd = { 'efm-langserver' },
    root_markers = { '.git' },
    filetypes = { 'json', 'svg', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'html' },
    init_options = {
        documentFormatting = true,
        codeAction = false,
    },
    root_dir = function(bufnr, on_dir)
        if vim.fs.root(bufnr, '.prettierrc.json') then
            on_dir(vim.fn.getcwd())
        end
    end,
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
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('format', {}),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    async = false,
                    filter = function(formatClient)
                        -- format only with this lsp
                        return formatClient.name == 'prettier'
                    end,
                })
            end
        })
    end,
}
