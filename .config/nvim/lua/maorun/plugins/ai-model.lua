return {
    {
        'gsuuon/model.nvim',
        cmd = { 'Mchat', 'Model' },
        ft = 'mchat',
        dependencies = {
            'folke/which-key.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        init = function()
            vim.filetype.add({
                extension = {
                    mchat = 'mchat',
                },
            })
        end,
        config = function()
            local model = require('model')
            local util = require('model.util')
            model.setup({
                default_prompt = require('model.providers.huggingface').default_prompt,
                chats = util.module.autoload('maorun/plugins/mchat/chat_library'),
                prompts = util.module.autoload('maorun/plugins/mchat/prompt_library'),
            })
        end
    }
}
