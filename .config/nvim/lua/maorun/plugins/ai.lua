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
            strategies = {
                chat = {
                    adapter = 'openai',
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
                },
                -- should_attach = function(_, bufname)
                --     if string.match(bufname, "env") then
                --         return false
                --     end

                --     return true
                -- end
            })
        end,
    },
}
