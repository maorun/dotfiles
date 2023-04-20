local wk = require("which-key")
-- wk.register({
--     ["<C-SPACE>"] = {'coc#refresh()', noremap = true },
--     ["<tab>"] = {'coc#pum#visible() ? coc#pum#confirm() : "<tab>"', noremap = true },
-- }, {mode = 'i', expr = true })
vim.cmd [[
     inoremap <silent><expr> <c-space> coc#refresh()
     inoremap <silent><expr> <s-tab> coc#pum#visible() ? coc#pum#confirm() : "\<s-tab>"

     augroup Cursor
     autocmd!
     " autocmd CursorHold * silent call CocActionAsync('highlight')
     "    autocmd CursorHoldI * :call <SID>show_hover_doc()
     "    autocmd CursorHold * :call <SID>show_hover_doc()
     augroup END

     highlight CocFloating ctermbg=black
     highlight CocMenuSel ctermbg=Grey guibg=DarkGrey

     function! ShowDocIfNoDiagnostic(args)
     if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
     "      silent call CocActionAsync('doHover')
     endif
     endfunction

     function! s:show_hover_doc()
     " call ShowDocIfNoDiagnostic()
     call timer_start(500, 'ShowDocIfNoDiagnostic')
     endfunction
]]

wk.register({
    c = {
        name = "COC",
        ["a"] = {"<Plug>(coc-codeaction)", "open coc", noremap = true},
        -- Apply AutoFix to problem on the current line.
        ["f"] = {"<Plug>(coc-fix-current)", "quickfix current problem", noremap = true },
        ["n"] = {"<plug>(coc-diagnostic-next)", "next problem", noremap = true },
        ["p"] = {"<Plug>(coc-diagnostic-prev)", "prev problem", noremap = true },
        ["r"] = {"<Plug>(coc-rename)", "rename", noremap = true },
        ["d"] = {"<Plug>(coc-definition)", "see definition", noremap = true },
        ["s"] = {"<Plug>(coc-references)", "see references", noremap = true },
        ["i"] = {"<Plug>(coc-implementation)", "goto implementations", noremap = true },
    },
}, { prefix = "<leader>" })

