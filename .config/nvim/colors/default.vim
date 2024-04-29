highlight MatchParen guifg=240 ctermbg=240
highlight Pmenu guibg=#222332
augroup statusline
    au!
    autocmd BufEnter fugitive://*  hi statusline guibg=Red ctermfg=Red guifg=OrangeRed4 ctermbg=White
    autocmd BufLeave fugitive://*  hi statusline guibg=NONE ctermfg=NONE cterm=bold,reverse guifg=NONE gui=bold,reverse ctermbg=NONE
augroup END

hi DiffChange   ctermfg=NONE          ctermbg=NONE

" set colorcolumn=80,120
" hi ColorColumn ctermbg=green
" call matchadd('ColorColumn', '\%81v', 100)

hi TelescopeSelection guibg=Gray ctermbg=Gray
