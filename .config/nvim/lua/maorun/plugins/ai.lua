return {
    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
        },
        keys = {
            {
                "<s-tab>",
                function()
                    -- if there is a previous edit, jump to it, otherwise apply it if any
                    if not require("sidekick").pes_jump_or_apply() then
                        return "<S-Tab>" -- fallback to normal shift-tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Previous Edit Suggestion",
            },
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                mode = { "n", "x", "i", "t" },
                desc = "Sidekick Switch Focus",
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({ focus = true })
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "v" },
            },
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "cursor", focus = true })
                end,
                desc = "Sidekick Claude Toggle",
                mode = { "n", "v" },
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").select_prompt()
                end,
                desc = "Sidekick Ask Prompt",
                mode = { "n", "v" },
            },
        },
    },
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
    -- {
    --     "franco-ruggeri/codecompanion-spinner.nvim",
    --     dependencies = {
    --         "olimorris/codecompanion.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     opts = {}
    -- },
    -- {
    --     'olimorris/codecompanion.nvim',
    --     opts = {
    --         adapters = {
    --             http = {
    --                 nmt = function()
    --                     return require("codecompanion.adapters").extend("openai_compatible", {
    --                         name = 'nmt',
    --                         env = {
    --                             -- url = "https://llm.tech.as-nmt.de/v1",
    --                             url = "https://litellm..dev.tech.as-nmt.de",
    --                             api_key = "sk-0ad3393c-a097-45b2-baa8-ffa11203ec9f",
    --                             chat_url = "/chat/completions",
    --                             models_endpoint = "/models",
    --                         },
    --                         headers = {
    --                             ["Content-Type"] = "application/json",
    --                             ["Authorization"] = "Bearer ${api_key}",
    --                         },
    --                         schema = {
    --                             model = {
    --                                 default = "eu.anthropic.claude-sonnet-4-5-20250929-v1:0",
    --                             },
    --                         },
    --                     })
    --                 end,
    --             }
    --         },
    --         strategies = {
    --             chat = {
    --                 adapter = 'nmt',
    --             },
    --             inline = {
    --                 adapter = 'copilot',
    --             },
    --             cmd = {
    --                 adapter = 'copilot',
    --             }
    --         },
    --         extensions = {
    --             mcphub = {
    --                 callback = "mcphub.extensions.codecompanion",
    --                 opts = {
    --                     make_vars = true,
    --                     make_slash_commands = true,
    --                     show_result_in_chat = true
    --                 }
    --             },
    --             contextfiles = {
    --                 opts = {
    --                 },
    --             }
    --         }
    --     },
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-treesitter/nvim-treesitter',
    --         'banjo/contextfiles.nvim',
    --     },
    -- },
}
