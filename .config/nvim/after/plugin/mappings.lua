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
wk.add({
    { "<C-E>", "<C-B>", desc = "Scroll up" },
    { "N", "Nzz", desc = "prev search" },
    { "cq", ":split | terminal aicommits -g 3<cr>a", desc = "aicommit", remap = false },
    { "cx", ":split | terminal opencommit<cr>a", desc = "opencommit", remap = false },
    { "gO", "O<Esc>", desc = "add a line above", remap = false },
    { "go", "o<Esc>", desc = "add a line below", remap = false },
    { "n", "nzz", desc = "next search" },
    { "<", "<gv", desc = "indent left", mode = "x" },
    { ">", ">gv", desc = "indent right", mode = "x" },
        { "<leader>b", group = "Buffer" },
    { "<leader>bd", ":%bd|e#<cr>", desc = "delete all buffers", remap = false },
    { "<leader>bn", NewBuffer, desc = "new buffer", remap = false },
    { "<leader>br", ReloadBuffer, desc = "reload buffer", remap = false },
    { "<leader>e", ":execute '!' .(expand(getline('.')))<cr>", desc = "execute line under cursor (shellescape does not work)", remap = false },
    { "<leader>f", group = "Formatting" },
    { "<leader>fj", ":%!jq .<cr>", desc = "JSON pretty print", remap = false },
    { "<leader>i", desc = "go to next indent", remap = false },
    { "<leader>pi", desc = "go to previous indent", remap = false },
    { "<leader>q", group = "General Commands" },
    { "<leader>qn", group = "Create new X" },
    { "<leader>qnb", NewBuffer, desc = "new buffer", remap = false },
    { "<leader>qr", group = "Run X" },
    { "<leader>qrd", "<c-w>s:terminal npm run dev<cr>", desc = "run npm-dev", remap = false },
    { "<leader>qri", "<c-w>s:terminal npm run image<cr>", desc = "run npm-image", remap = false },
    { "<leader>qrt",
        function()
            Job({
                command = 'npm',
                args = { 'run', 'test', '--ignore-scripts' },
            })
        end, desc = "run tests", remap = false },
    { "<leader>w", ":w<cr>zvzz", desc = "Save", remap = false },

    { "ie", ':exec "normal! ggVG"<cr>', desc = "select all", mode = "o", remap = false },

    -- { "<C-J>", "<Down>", desc = "float-menu down", mode = "i", remap = false },
    -- { "<C-K>", "<Up>", desc = "float-menu up", mode = "i", remap = false },

  })


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

-- wk.register({
--     ["<C-L>"] = { "<C-O>l", "move cursor right", noremap = true},
--     ["<C-H>"] = { "<C-O>h", "move cursor left", noremap = true},
-- }, { mode = 'i'})

-- moving lines
-- wk.register({
--     J = { ":m '>+1<cr>gv=gv", "move line down", noremap = true },
--     K = { ":m '<-2<cr>gv=gv", "move line up", noremap = true },
-- }, { mode = 'v' })
-- wk.register({
--     ["<C-K>"] = { "mk:m .-2<cr>==`k", "move line up", noremap = true },
--     ["<C-J>"] = { "mk:m .+1<cr>==`k", "move line down", noremap = true },
-- }, { mode = 'n' })
