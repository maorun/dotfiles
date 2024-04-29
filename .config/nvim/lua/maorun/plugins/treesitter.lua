return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { 'graphql', 'lua', 'html', 'php', 'javascript', 'tsx', 'typescript', 'bash', 'make', 'markdown', 'regex', 'vim', 'vimdoc', 'yaml' },
                syncinstall = true,
                -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim
                highlight = {
                    enable = true
                },
                textobjects = {
                    select = {
                        enable = true
                    }
                },
                indent = {
                    enable = true
                },
                playground = {
                    enable = false,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = 'o',
                        toggle_hl_groups = 'i',
                        toggle_injected_languages = 't',
                        toggle_anonymous_nodes = 'a',
                        toggle_language_display = 'I',
                        focus_language = 'f',
                        unfocus_language = 'F',
                        update = 'R',
                        goto_node = '<cr>',
                        show_help = '?',
                    }
                },
                matchup = {
                    enable = true
                },
            }

            -- require'nvim-treesitter.configs'.setup {
            --     autotag = {
            --     enable = true,
            --     filetypes = {
            --         'html',
            --         'xml',
            --         'javascript',
            --         'javascriptreact',
            --         'typescript',
            --         'typescriptreact',
            --         'vue',
            --         'svelte'
            --         }
            --     },
            --     matchup = {
            --     enable = true,
            --     },
            -- }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = "VimEnter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        init = function()
            require 'treesitter-context'.setup {
                max_lines = 10,
            }
        end
    }
    -- , 'nvim-treesitter/playground'
}
