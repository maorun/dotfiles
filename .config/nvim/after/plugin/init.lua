if vim.fn.filereadable(vim.fn.expand(".vimrc_project.lua")) == 1 then
    vim.cmd("source .vimrc_project.lua")
end

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- for vimrc_project
vim.cmd [[
        if exists("*PostVimRc")
        :call PostVimRc()
        endif
        ]]
