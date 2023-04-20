            local actions = require('telescope.actions')
            local action_layout = require('telescope.actions.layout')
            local gitActions = require('maorun.telescope.gitActions').actions

            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = {
                        '.git/*',
                        'node_modules',
                        '__snapshots__',
                        'package%-lock%.json',
                        'composer%.lock'
                    },
                    mappings = {
                        i = {
                            ['<C-p>'] = actions.results_scrolling_up,
                            ['<C-f>'] = actions.results_scrolling_down,
                            ['<C-O>'] = action_layout.toggle_preview,
                            ['<PageUp>'] = false,
                            ['<PageDown>'] = false,
                            ['<Down>'] = false,
                            ['<C-j>'] = actions.move_selection_next,
                            ['<Up>'] = false,
                            ['<C-k>'] = actions.move_selection_previous,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        mappings ={
                            i = {
                                ["<c-d>"] = actions.delete_buffer,
                            },
                        },
                    },
                    git_branches = {
                        mappings = {
                            i = {
                                ['<c-d>'] = gitActions.git_delete_branch + gitActions.showGitBranches,
                            }
                        }
                    }
                },
                extensions = {
                    file_browser = {
                        respect_gitignore = false,
                        hidden = true,
                        depth = 4,
                    },
                    project = {
                        base_dirs = {
                            '~/repos',
                        },
                        hidden_files = true,
                        on_project_selected = function(prompt_bufnr)
                            local project_actions = require("telescope._extensions.project.actions")
                            project_actions.change_working_directory(prompt_bufnr, false)
                            require "telescope".extensions.file_browser.file_browser({ 
                                respect_gitignore = true,
                            })

                        end
                    },
                    gkeep = {
                        find_method = 'all_text',
                        link_method = 'title',
                    },
                },
            })
            -- vim.api.nvim_create_autocmd("TelescopePreviewerLoaded ", {
            --     group = 'User',
            --     command = 'setlocal wrap'
            -- })

