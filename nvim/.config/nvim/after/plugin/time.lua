require'maorun.time'.setup()

local wk = require("which-key")
wk.register({
    t = {
        t = {
            name = "Time",
            s = {"<cmd>lua Time.TimeStop()<cr>", "TimeStop", noremap = true},
            p = {"<cmd>lua Time.TimePause()<cr>", "TimePause", noremap = true},
            r = {"<cmd>lua Time.TimeResume()<cr>", "TimeResume", noremap = true},
        }
    },
}, { prefix = "<leader>" })

