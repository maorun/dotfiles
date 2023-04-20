local wk = require("which-key")
wk.register({
    ["¡"] = {"<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "navigate to file 1", noremap = true},
    ["™"] = {"<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "navigate to file 2", noremap = true},
    ["£"] = {"<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "navigate to file 3", noremap = true},
    ["¢"] = {"<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "navigate to file 4", noremap = true},

}, { silent=true, prefix = '' })
wk.register({
    a = {":lua require('harpoon.mark').add_file()<cr>", "Add file to mark", noremap = true},
    t = {
        h = { ":Telescope harpoon marks<cr>", "Harpoon marks", noremap = true },
    },
}, { silent=true, prefix = '<leader>' })
require("telescope").load_extension('harpoon')
