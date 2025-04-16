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
        end
    }
}
