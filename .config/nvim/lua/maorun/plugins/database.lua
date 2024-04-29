return {
    {
        'kristijanhusak/vim-dadbod-ui', -- Database-UI
        cmd = 'DBUI',
        dependencies = {
            'tpope/vim-dadbod'
        }
    },
    {
        'tpope/vim-dadbod', -- Database
        cmd = 'DBUI',
        init = function()
            local dbAuGroup = vim.api.nvim_create_augroup("user_db", {})
            vim.api.nvim_create_autocmd("FileType", {
                group = dbAuGroup,
                pattern = "dbout",
                command = "setlocal nofoldenable",
            })
            vim.api.nvim_create_autocmd("User", {
                group = dbAuGroup,
                pattern = "DBUIOpened",
                command = "setlocal relativenumber number",
            })
        end,
    }
}
