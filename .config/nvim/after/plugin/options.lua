vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.conceallevel = 0

vim.opt.showcmd = true
vim.opt.title = true
vim.opt.ruler = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = true
vim.opt.scrolloff=5
vim.opt.laststatus=2

vim.opt.list = true
vim.opt.listchars={tab="!·", trail="·"}

-- " completion
vim.opt.complete= vim.opt.complete + "kspell"

-- " searching
vim.opt.hls = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- " undofile
vim.opt.undodir = vim.fn.stdpath('data') .. "/undodir"
vim.opt.undofile = true

-- " swapfile
vim.opt.swapfile = false

vim.opt.termguicolors = true

vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.autoindent = true

function GetSize()
    local calc = tonumber(vim.fn.system('calc-diff-num'))
    local size = ''
    if (calc < 10) then
        size = 'XS'
    elseif (calc < 30) then
        size = 'S'
    elseif (calc < 100) then
        size = 'M'
    elseif (calc < 500) then
        size = 'L'
    elseif (calc < 1000) then
        size = 'XL'
    else
        size = 'XXL'
    end
    return calc .. ' => ' .. size
end

function GetSizeStaged()
    local calc = tonumber(vim.fn.system('calc-diff-num --staged'))
    local size = ''
    if (calc < 10) then
        size = 'XS'
    elseif (calc < 30) then
        size = 'S'
    elseif (calc < 100) then
        size = 'M'
    elseif (calc < 500) then
        size = 'L'
    elseif (calc < 1000) then
        size = 'XL'
    else
        size = 'XXL'
    end
    return calc .. ' => ' .. size
end

vim.opt.statusline="%<"
vim.opt.statusline=vim.opt.statusline + "%="
vim.opt.statusline=vim.opt.statusline + "%{get(b:,'gitsigns_head','')}%="
vim.opt.statusline=vim.opt.statusline + "Unstaged: %{luaeval(\"GetSize()\")}%="
vim.opt.statusline=vim.opt.statusline + "Staged: %{luaeval(\"GetSizeStaged()\")}%="
vim.opt.statusline=vim.opt.statusline + "%f" -- the filename
vim.opt.statusline=vim.opt.statusline + " %h" -- help-buffer
vim.opt.statusline=vim.opt.statusline + "%m" -- modified-flag
vim.opt.statusline=vim.opt.statusline + "%r" -- read-onlyflag
vim.opt.statusline=vim.opt.statusline + "%="
if pcall(require, "maorun.code-stats") then
    vim.opt.statusline=vim.opt.statusline + "%{luaeval(\"require('maorun.code-stats').currentXp()\")} "
end
vim.cmd [[
    "set statusline+=Session:\ %{ObsessionStatus('[active]','[paused]')}
    set statusline+=\ %-14.(%l,%c%V%)\ %P
    "set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
]]

-- " not waiting too long
vim.opt.updatetime=2000

vim.opt.shortmess=vim.opt.shortmess + "c"

-- " finding files
vim.opt.path= vim.opt.path + "**"
vim.opt.wildmode= "longest,list,full"
vim.opt.wildmenu = true
vim.opt.wildignore= vim.opt.wildignore + "**/node_modules/*,**/vendor/*"

vim.opt.foldenable=true
vim.opt.foldlevelstart=999
vim.opt.foldmethod="expr"
vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.cmd [[
    augroup VimRcRead
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker foldenable
        autocmd BufRead *.json setlocal foldmethod=syntax
    augroup END

    autocmd BufRead *.txt setlocal nospell spelllang=de,en foldmethod=marker foldenable

    syntax enable

    filetype plugin indent on

]]
