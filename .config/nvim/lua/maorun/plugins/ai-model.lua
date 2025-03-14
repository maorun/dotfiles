return {
    {
        'gsuuon/model.nvim',
        dependencies = {
            'folke/which-key.nvim',
            'nvim-treesitter/nvim-treesitter'
        },
        init = function()
            local model = require('model')
            vim.filetype.add({
                extension = {
                    mchat = 'mchat',
                }
            })

            local util = require('model.util')
            model.setup({
                default_prompt = require('model.providers.huggingface').default_prompt,
                chats = util.module.autoload('maorun/plugins/mchat/chat_library'),
                prompts = util.module.autoload('maorun/plugins/mchat/prompt_library'),
            })

            local augroup = vim.api.nvim_create_augroup('ai_model', {})
            vim.api.nvim_create_autocmd('FileType', {
                group = augroup,
                pattern = 'mchat',
                command = 'nnoremap <silent><buffer> <leader>w :Mchat<cr>',
            })
            vim.api.nvim_create_autocmd('FileType', {
                group = augroup,
                pattern = 'gitcommit',
                callback = function()
                    vim.opt.spell = true
                    local wk = require('which-key')
                    wk.add({
                        { '<leader>gc', ':M commit<cr>', desc = 'generate message', remap = true },
                    })
                end
            })
        end
    }
}
