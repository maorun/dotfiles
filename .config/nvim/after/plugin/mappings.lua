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

