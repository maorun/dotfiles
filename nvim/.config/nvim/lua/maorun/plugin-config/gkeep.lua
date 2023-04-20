require('telescope').load_extension('gkeep')
local keepNote = vim.api.nvim_create_augroup("GoogleKeepNote", {})
vim.api.nvim_create_autocmd("FileType", {
    group = keepNote,
    pattern = "GoogleKeepNote,GoogleKeepList",
    command = "set number relativenumber",
})

