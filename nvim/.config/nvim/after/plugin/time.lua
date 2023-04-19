require'telescope'.load_extension('time')

local wk = require("which-key")
wk.register({
t = {
    name = "Time",
    t = {"<cmd>Telescope time<cr>", "TimePicker"},
},
}, { prefix = "<leader>" })
