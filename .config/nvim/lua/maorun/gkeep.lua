require('telescope').load_extension('gkeep')
local wk = require("which-key")

local keepNote = vim.api.nvim_create_augroup("GoogleKeepNote", {})
vim.api.nvim_create_autocmd("FileType", {
    group = keepNote,
    pattern = "GoogleKeepNote,GoogleKeepList",
    command = "set number relativenumber",
})

wk.register({
    t = {
        g = { ':GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>', "Google Keep", noremap = true },
    },
}, { silent=true, prefix = '<leader>' })
