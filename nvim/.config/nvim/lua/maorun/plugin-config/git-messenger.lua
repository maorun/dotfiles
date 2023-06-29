local wk = require("which-key")

wk.register({
    ["<c-w>"] = {
        m = {"<Plug>(git-messenger-into-popup)", "Git Messenger switch", noremap = true},
    }
}, {})

