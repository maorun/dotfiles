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
    opts = vim.tbl_deep_extend("keep", opts or {}, {
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
        print('start "' .. opts.command .. " " .. table.concat(opts.args, ' ') .. '"')
    end
    plenaryJob:new(opts):start()
end

local wk = require("which-key")
wk.register({
    ['<C-E>'] = { "<C-B>", "Scroll up" },
    g = {
        o = { "o<Esc>", "add a line below", noremap = true },
        O = { "O<Esc>", "add a line above", noremap = true },
    },
    cq = { ":split | terminal aicommits -g 3<cr>a", "aicommit", noremap = true },
    cx = { ":split | terminal opencommit<cr>a", "opencommit", noremap = true },
    n = { "nzz", "next search" },
    N = { "Nzz", "prev search" },
}, { silent = true, prefix = '' })
wk.register({
    [">"] = { ">gv", "indent right" },
    ["<"] = { "<gv", "indent left" },
}, { silent = true, mode = "x", prefix = '' })

wk.register({
    q = {
        name = "General Commands",
        n = {
            name = "Create new X",
            b = { NewBuffer, "new buffer", noremap = true },
            g = { ':GkeepNew<cr>', 'new google-note', noremap = true }
        },
        r = {
            name = "Run X",
            t = {
                function()
                    Job({
                        command = 'npm',
                        args = { 'run', 'test', '--ignore-scripts' },
                    })
                end,
                "run tests",
                noremap = true
            },
            i = { '<c-w>s:terminal npm run image<cr>', 'run npm-image', noremap = true },
            d = { '<c-w>s:terminal npm run dev<cr>', 'run npm-dev', noremap = true },
        },
    },
    d = {
        name = "Diff",
        d = { ":diffthis<cr>", "Diff this", noremap = true },
        q = { ":diffoff!<cr>", "Diff off", noremap = true },
    },
    w = { ":w<cr>zvzz", "Save", noremap = true },
    f = {
        name = "Formatting",
        j = { ":%!jq .<cr>", "JSON pretty print", noremap = true },
    },
    i = { "go to next indent", noremap = true },
    pi = { "go to previous indent", noremap = true },
    e = { ":execute '!' .(expand(getline('.')))<cr>", "execute line under cursor (shellescape does not work)", noremap = true },
    b = {
        name = "Buffer",
        n = { NewBuffer, "new buffer", noremap = true },
        r = { ReloadBuffer, "reload buffer", noremap = true },
        d = { ':%bd|e#<cr>', "delete all buffers", noremap = true },
    },
}, { silent = true, prefix = '<leader>' })

vim.cmd [[
    inoremap jk <Esc>
    vnoremap jk <Esc>
    cnoremap jk <Esc>

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

wk.register({
    ie = { ':exec "normal! ggVG"<cr>', "select all", noremap = true },
}, { mode = 'o', remap = false })

-- wk.register({
--     ["<C-L>"] = { "<C-O>l", "move cursor right", noremap = true},
--     ["<C-H>"] = { "<C-O>h", "move cursor left", noremap = true},
-- }, { mode = 'i'})

-- moving lines
wk.register({
    J = { ":m '>+1<cr>gv=gv", "move line down", noremap = true },
    K = { ":m '<-2<cr>gv=gv", "move line up", noremap = true },
}, { mode = 'v' })
wk.register({
    ["<C-K>"] = { "mk:m .-2<cr>==`k", "move line up", noremap = true },
    ["<C-J>"] = { "mk:m .+1<cr>==`k", "move line down", noremap = true },
}, { mode = 'n' })

wk.register({
    -- " float-menu up and down
    ["<C-J>"] = { "<Down>", "float-menu down", noremap = true },
    ["<C-K>"] = { "<Up>", "float-menu up", noremap = true },
    --     ["<C-J>"] = { "<Esc>mk:m .+1<cr>==`ka", "move line down", noremap = true},
    --     ["<C-K>"] = { "<Esc>mk:m .-2<cr>==`ka", "move line up", noremap = true},
}, { mode = 'i' })
