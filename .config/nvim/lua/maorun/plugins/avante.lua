return {
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
            provider = 'ollama',
            max_tokens = 4096,
            ollama = {
                endpoint = 'http://127.0.0.1:11434/v1',
                model = 'codestral',
                -- deepseek-coder-v2
                -- codestral
                -- codellama
                -- qwen2.5-coder:32b
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = 'make',
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            --- The below dependencies are optional,
            'hrsh7th/nvim-cmp',            -- autocompletion for avante commands and mentions
            'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        },
    }
}
