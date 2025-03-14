vim.cmd "nnoremap gx yiW:!open '<cWORD>'<CR><CR>"
vim.cmd "nnoremap gix yib:!open '<c-r>\"'<CR><CR>"

-- got to indention level {{{
vim.cmd [[
    function! s:indent_len(str)
        return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
    endfunction
    function! s:go_indent(times, dir)
        for _ in range(a:times)
            let l = line('.')
            let x = line('$')
            let i = s:indent_len(getline(l))
            let e = empty(getline(l))

            while l >= 1 && l <= x
                let line = getline(l + a:dir)
                let l += a:dir
                if s:indent_len(line) != i || empty(line) != e
                    break
                endif
            endwhile
            let l = min([max([1, l]), x])
            execute 'normal! '. l .'G^'
        endfor
    endfunction

    nnoremap <silent> <leader>i :<c-u>call <SID>go_indent(v:count1, 1)<cr>
    nnoremap <silent> <leader>pi :<c-u>call <SID>go_indent(v:count1, -1)<cr>
]]
-- }}}

NewBuffer = function(args)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_command('split')
    local curr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(curr, buf)
    vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(0, 'swapfile', false)
    if (args ~= nil) then
        vim.api.nvim_buf_set_lines(0, 0, -1, true, args)
    end
end

local ReloadBuffer = function()
    local buf = vim.api.nvim_create_buf(false, true)
    local curr = vim.api.nvim_get_current_win()
    local col = vim.fn.charcol('.')
    local line = vim.fn.line('.')
    vim.api.nvim_command('split')
    vim.api.nvim_win_set_buf(curr, buf)
    vim.api.nvim_set_current_win(curr)
    local file = vim.api.nvim_buf_get_name(0)
    vim.api.nvim_buf_delete(0, {})
    vim.api.nvim_command('edit ' .. file)
    -- vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_cursor(0, { line, col - 1 })
    print('buffer reload')
end

function Job(opts)
    local lines = {}
    opts = vim.tbl_deep_extend('keep', opts or {}, {
        silent = false,
        command = '',
        args = {},
        interactive = false,
        on_stdout = function(_, data)
            table.insert(lines, data)
        end,
        on_stderr = function(_, data)
            table.insert(lines, data)
        end,
        on_exit = function()
            vim.schedule(function()
                vim.api.nvim_command('new')
                if (opts.silent ~= true) then
                    NewBuffer(lines)
                end
            end)
        end,
    })

    local plenaryJob = require 'plenary.job'
    if (opts.silent ~= true) then
        print('start "' .. opts.command .. ' ' .. table.concat(opts.args, ' ') .. '"')
    end
    plenaryJob:new(opts):start()
end

local wk = require('which-key')
wk.add({
    { '<C-E>',      '<C-B>',                                    desc = 'Scroll up' }, -- because of tmux
    { 'N',          'Nzz',                                      desc = 'prev search' },
    { 'gO',         'O<Esc>',                                   desc = 'add a line above', },
    { 'go',         'o<Esc>',                                   desc = 'add a line below', },
    { 'n',          'nzz',                                      desc = 'next search' },
    { '<',          '<gv',                                      desc = 'indent left',                                           mode = 'x' },
    { '>',          '>gv',                                      desc = 'indent right',                                          mode = 'x' },
    { '<leader>b',  group = 'Buffer' },
    { '<leader>bd', ':%bd|e#<cr>',                              desc = 'delete all buffers', },
    { '<leader>br', ReloadBuffer,                               desc = 'reload buffer', },
    { '<leader>e',  ":execute '!' .(expand(getline('.')))<cr>", desc = 'execute line under cursor (shellescape does not work)', },
    { '<leader>f',  group = 'Formatting' },
    { '<leader>fj', ':%!jq .<cr>',                              desc = 'JSON pretty print', },
    { '<leader>i',  desc = 'go to next indent', },
    { '<leader>pi', desc = 'go to previous indent', },
    { '<leader>q',  group = 'General Commands' },
    { '<leader>w',  ':w<cr>zvzz',                               desc = 'Save', },

    { 'ihe',        ':exec "normal! ggVG"<cr>',                 desc = 'select all',                                            mode = 'o', },

    { '<C-h>',      '<C-g>u<Esc>[s1z=`]a<C-g>u',                desc = 'fix prev spelling mistake',                             mode = 'i' },
    { 'jk',         '<Esc>',                                    desc = 'to normal mode',                                        mode = { 'i', 'v', 'c' } },
})


vim.cmd [[

    " yank and paste to/from system-clipboard (Mac)
    vnoremap <silent> ç "+y
    vnoremap <silent> <M-c> "+y
    nnoremap <silent> ç :set operatorfunc=CopyToSystemClipboard<cr>g@
    nnoremap <silent> <M-c> :set operatorfunc=CopyToSystemClipboard<cr>g@
    nnoremap <silent> √ "+p
    nnoremap <silent> <M-v> "+p
    inoremap <silent> √ <Esc>"+pa
    inoremap <silent> <M-v> <Esc>"+pa

    function! CopyToSystemClipboard(type)
        if a:type ==# 'line'
            silent execute "normal! `[V`]\"+y"
        elseif a:type ==# 'char'
            silent execute "normal! `[v`]\"+y"
        else
            return
        endif

        " echo @@ "yanked into clipboard"
    endfunction

]]
