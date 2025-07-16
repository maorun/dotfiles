return {
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- provider = 'codellama',
            provider = 'openai',
            cursor_applying_provider = 'ollama',
            -- cursor_applying_provider = 'openai',
            -- behaviour = {
            --     enable_cursor_planning_mode = true,
            -- },
            auto_suggestions_provider = 'openai',
            -- auto_suggestions_provider = 'ollama',
            -- max_tokens = 4096,
            providers = {
                codellama = {
                    __inherited_from = 'ollama',
                    model = 'codellama:13b'
                },
                deepseek_r = {
                    __inherited_from = 'ollama',
                    model = 'deepseek-r1:7b',
                },
                qwen2 = {
                    __inherited_from = 'ollama',
                    model = 'qwen2.5-coder:32b',
                },
                ollama = {
                    endpoint = 'http://127.0.0.1:11434',
                    model = 'codellama',
                    -- deepseek-coder-v2
                    -- codestral
                    -- codellama
                    -- qwen2.5-coder:32b
                },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = 'make',
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'stevearc/dressing.nvim',
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            --- The below dependencies are optional,
            'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
            'hrsh7th/nvim-cmp',              -- autocompletion for avante commands and mentions
            'nvim-tree/nvim-web-devicons',   -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        },
    }
}
