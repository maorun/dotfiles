require'telescope'.load_extension('secrets')

local wk = require("which-key")
wk.register({
t = {
    s = {"<cmd>Telescope secrets<cr>", "SecretsPicker"},
},
}, { prefix = "<leader>" })
