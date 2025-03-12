return {
    {
        'maorun/codeium.nvim',
        enabled = false, -- only online usable and cannot be disabled on-the-fly
        -- event = 'InsertEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        init = function()
            require('codeium').setup({})
        end
    },
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
    {
        enabled = false, -- only usable with openai
        'jackMort/ChatGPT.nvim',
        event = 'VimEnter',
        init = function()
            package.loaded['chatgpt.api'] = nil
            package.loaded['chatgpt.flows.chat.base'] = nil
            package.loaded['chatgpt.flows.chat'] = nil
            package.loaded['chatgpt.module'] = nil
            package.loaded['chatgpt.settings'] = nil
            package.loaded['chatgpt.config'] = nil
            package.loaded['chatgpt'] = nil
            require('chatgpt').setup({
                api_host_cmd = 'echo -n http://0.0.0.0:8000',
                api_key_cmd = 'noting',
                openai_params = {
                    stream = false,
                }
            })
        end,
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
            'folke/trouble.nvim',
            'nvim-telescope/telescope.nvim'
        },
    }
}
