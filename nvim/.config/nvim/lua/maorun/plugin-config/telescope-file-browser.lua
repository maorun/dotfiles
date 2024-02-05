require("telescope").load_extension "file_browser"

local wk = require("which-key")

wk.register({
    v = {
        e = {function()
            require('telescope').extensions.file_browser.file_browser({
                path = "~/dotfiles/",
                prompt_title = "* dotfiles *",
            })
        end, "find file in dotfiles", noremap = true},
    },
    n = {
        name = "FileTree",
        f = {":Telescope file_browser path=%:p:h select_buffer=true<cr>", "current file", noremap = true},
        t = {":Telescope file_browser respect_gitignore=true<cr>", "open tree", noremap = true},
    },
}, { prefix = "<leader>" })

