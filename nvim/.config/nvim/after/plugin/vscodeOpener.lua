function OpenCurrentFileInVisualCode()
    local x,y=string.find(vim.fn.expand("%:p"), "/", 17);
    local possibleRepo = string.sub(vim.fn.expand("%:p"), 0, y)
    local file = vim.fn.expand("%:p")
    vim.fn.system("code " .. possibleRepo .. " " .. file)
end

local wk = require "which-key"
wk.register({
    q = {
        name = "General Commands",
        o = {":lua OpenCurrentFileInVisualCode()<CR>", "open current file in visual code", noremap = true},
    },
}, { prefix = "<leader>" })
