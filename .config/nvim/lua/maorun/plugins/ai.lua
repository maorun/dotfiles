return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        init = function()
            require('copilot').setup({
                suggestion = {
                    -- auto_trigger = true,
                    keymap = {
                        next = '<C-l>',
                        prev = '<C-h>',
                        accept = '<C-;>',
                    }
                }
            })
            local ns = vim.api.nvim_create_namespace ',r.copilot'

            require('copilot.api').register_status_notification_handler(function(data)
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                if vim.fn.mode() == 'i' and data.status == 'InProgress' then
                    vim.api.nvim_buf_set_extmark(0, ns, vim.fn.line '.' - 1, 0, {
                        virt_text = { { ' 🤖Thinking...', 'Comment' } },
                        virt_text_pos = 'eol',
                        hl_mode = 'combine',
                    })
                end
            end)
        end,
    },
}
