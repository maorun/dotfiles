local rpcBuf = nil
local rpcWin = nil

local RPCBuffer = function(args)
    if (rpcBuf == nil or vim.api.nvim_buf_is_valid(rpcBuf) == false) then
        rpcBuf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(rpcBuf, 'RPC')
        vim.api.nvim_buf_set_option(rpcBuf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(rpcBuf, 'buflisted', false)
        vim.api.nvim_buf_set_option(rpcBuf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(rpcBuf, 'swapfile', false)
    end
    if (args ~= nil) then
        vim.api.nvim_buf_set_lines(rpcBuf, 0, -1, false, args)
    end
end

--- CurlJob
-- @param {string} url
-- @param {table} opts
--                  query = {}
--                  body = {},
--                  headers = {},
--                  form = {},
--                  dry_run = true | false
local function CurlJob(url, opts)
    local plenaryCurl = require 'plenary.curl'
    opts = vim.tbl_deep_extend("keep", opts or {}, {
        callback = function(ret)
            vim.schedule(function()
                if (opts.type == 'json') then
                    RPCBuffer({ ret.body })
                    vim.api.nvim_buf_set_option(rpcBuf, 'filetype', 'json')
                    vim.api.nvim_buf_call(rpcBuf, function()
                        vim.cmd('%!jq')
                   end)
                else
                    RPCBuffer({'success'})
                end

                if (rpcWin == nil or vim.api.nvim_win_is_valid(rpcWin) == false) then
                    local actualWin = vim.api.nvim_get_current_win()
                    vim.api.nvim_command('vnew')
                    rpcWin = vim.api.nvim_get_current_win()
                    vim.api.nvim_set_current_win(actualWin)
                end
                vim.api.nvim_win_set_buf(rpcWin, rpcBuf)
            end)
        end
    })
    if (opts.method == 'post') then
        plenaryCurl.post(url, opts)
else
    plenaryCurl.get(url, opts)
end
end

return {
    CurlJob = CurlJob
}
