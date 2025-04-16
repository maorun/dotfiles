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

ReloadBuffer = function()
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

