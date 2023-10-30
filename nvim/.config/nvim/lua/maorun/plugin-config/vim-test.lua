local wk = require("which-key")

wk.register({
    v = {
        t = {
            n = {":TestNearest<cr>", "runs the test nearest to the cursor", noremap = true},
            s = {":TestSuite<cr>", "runs the whole test suite", noremap = true},
            f = {":TestFile<cr>", "runs the whole test file", noremap = true},
        }
    }
}, {prefix = "<leader>"})

