vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
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


-- " Color column
vim.opt.colorcolumn="80,120"
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.statusline="%<"
vim.opt.statusline=vim.opt.statusline + "%="
vim.opt.statusline=vim.opt.statusline + "%f" -- the filename
vim.opt.statusline=vim.opt.statusline + " %h" -- help-buffer
vim.opt.statusline=vim.opt.statusline + "%m" -- modified-flag
vim.opt.statusline=vim.opt.statusline + "%r" -- read-onlyflag
vim.opt.statusline=vim.opt.statusline + "%="
vim.cmd [[
    set statusline+=%{CodeStatsXp()}\ 
    set statusline+=Session:\ %{ObsessionStatus('[active]','[paused]')}
    set statusline+=\ %-14.(%l,%c%V%)\ %P
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
    augroup statusline
        au!
        autocmd BufEnter fugitive://*  hi statusline guibg=Red ctermfg=Red guifg=OrangeRed4 ctermbg=White
        autocmd BufLeave fugitive://*  hi statusline guibg=NONE ctermfg=NONE cterm=bold,reverse guifg=NONE gui=bold,reverse ctermbg=NONE
    augroup END
]]

-- " not waiting too long
vim.opt.updatetime=1000
vim.cmd "autocmd FileType php setlocal updatetime=2000"

vim.opt.shortmess=vim.opt.shortmess + "c"

-- " finding files
vim.opt.path= vim.opt.path + "**"
vim.opt.wildmode= "longest,list,full"
vim.opt.wildmenu = true
vim.opt.wildignore= vim.opt.wildignore + "**/node_modules/*,**/vendor/*"

vim.opt.foldenable=false
vim.opt.foldmethod="indent"
vim.cmd [[
    augroup VimRcRead
        autocmd!
        autocmd FileType lua setlocal foldmethod=marker foldenable
        autocmd FileType vim setlocal foldmethod=marker foldenable
        autocmd BufRead *.json setlocal foldmethod=syntax
    augroup END

    autocmd BufRead *.txt setlocal nospell spelllang=de,en foldmethod=marker foldenable

    syntax enable

    hi ColorColumn ctermbg=green
    call matchadd('ColorColumn', '\%81v', 100)

    filetype plugin indent on

]]
