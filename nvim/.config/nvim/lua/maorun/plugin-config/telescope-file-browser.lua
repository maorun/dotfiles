local wk = require("which-key")

require("telescope").load_extension "file_browser"

wk.register({
    n = {
        name = "FileTree",
        f = {":Telescope file_browser path=%:p:h select_buffer=true<cr>", "current file", noremap = true},
        t = {":Telescope file_browser respect_gitignore=true<cr>", "open tree", noremap = true},
    },
}, { prefix = "<leader>" })

