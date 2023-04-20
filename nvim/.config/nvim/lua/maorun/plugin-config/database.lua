local fugitiveAuGroup = vim.api.nvim_create_augroup("user_fugitive", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = fugitiveAuGroup,
    pattern = "fugitive://*",
    command = "set bufhidden=delete",
})

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
