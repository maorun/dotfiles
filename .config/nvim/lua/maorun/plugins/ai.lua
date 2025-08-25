return {
    {
        'ravitemer/mcphub.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        config = function()
            require("mcphub").setup()
        end
    },
    {
        "franco-ruggeri/codecompanion-spinner.nvim",
        dependencies = {
            "olimorris/codecompanion.nvim",
            "nvim-lua/plenary.nvim",
        },
        opts = {}
    },
    {
        'olimorris/codecompanion.nvim',
        opts = {
            adapters = {
                nmt = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = 'nmt',
                        env = {
                            url = "https://llm.tech.as-nmt.de/v1",
                            api_key = "sk-0ad3393c-a097-45b2-baa8-ffa11203ec9f",
                            chat_url = "/chat/completions",
                            models_endpoint = "/models",
                        },
                        headers = {
                            ["Content-Type"] = "application/json",
                            ["Authorization"] = "Bearer ${api_key}",
                        },
                        schema = {
                            model = {
                                default = "us.deepseek.r1-v1:0",
                            },
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = 'nmt',
                },
                inline = {
                    adapter = 'copilot',
                },
                cmd = {
                    adapter = 'copilot',
                }
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true
                    }
                }
            }
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
    },
}
