return {
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            local actions = require('telescope.actions')
            local action_layout = require('telescope.actions.layout')
            local gitActions = require('maorun.plugin-config.telescope.gitActions').actions

            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = {
                        '.cache/',
                        '.obsidian/',
                        '.trash/',
                        '.next/',
                        'vendor/',
                        '.git/',
                        'node_modules',
                        '__snapshots__',
                        'package%-lock%.json',
                        'packages/products',
                        'packages/mdb-',
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
                    oldfiles = {
                        mappings = {
                            i = {
                                ['<C-d>'] = function(prompt_bufnr)
                                    local action_state = require('telescope.actions.state')
                                    local telescope_builtin = require('telescope.builtin')

                                    -- Get the selected entry
                                    local entry = action_state.get_selected_entry()
                                    if not entry then return end

                                    -- Remove the selected file from v:oldfiles
                                    vim.v.oldfiles = vim.tbl_filter(function(file)
                                        return file ~= entry.value
                                    end, vim.v.oldfiles)

                                    -- don't save changes to ShaDa file because everything is lost after restart of vim (also the entries not in cwd)
                                    -- vim.cmd('wshada!')

                                    -- Schließe den Picker und öffne ihn neu **mit cwd_only = true**
                                    actions._close(prompt_bufnr, true)              -- Schließt den Picker sauber
                                    telescope_builtin.oldfiles({ cwd_only = true }) -- Neu mit Filter
                                end,
                            },
                        },
                    },
                    buffers = {
                        mappings = {
                            i = {
                                ['<c-d>'] = actions.delete_buffer,
                            },
                        },
                    },
                    git_stash = {
                        mappings = {
                            i = {
                                ['<c-d>'] = gitActions.git_delete_stash,
                                ['<C-f>'] = actions.preview_scrolling_down,
                            }
                        }

                    },
                    git_branches = {
                        mappings = {
                            i = {
                                ['<c-d>'] = gitActions.git_delete_branch + gitActions
                                    .showGitBranches,
                            }
                        }
                    }
                },
                extensions = {
                    file_browser = {
                        respect_gitignore = false,
                        hidden = true,
                        depth = 4,
                        auto_depth = true,
                    },
                    project = {
                        base_dirs = {
                            '~/repos',
                        },
                        hidden_files = true,
                        on_project_selected = function(prompt_bufnr)
                            local project_actions = require('telescope._extensions.project.actions')
                            project_actions.change_working_directory(prompt_bufnr, false)
                            -- require "telescope".extensions.file_browser.file_browser({
                            --     respect_gitignore = true,
                            -- })
                        end
                    },
                },
            })
            -- vim.api.nvim_create_autocmd("TelescopePreviewerLoaded ", {
            --     group = 'User',
            --     command = 'setlocal wrap'
            -- })
            -- Load user extension
        end,
        dependencies = {
            {
                'BurntSushi/ripgrep',
                event = 'VimEnter',
            },                                 -- for live_grep and find_files
            'nvim-treesitter/nvim-treesitter', -- finder/preview
        },
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('telescope').load_extension 'file_browser'
        end,
    },
    {
        event = 'VimEnter',
        'nvim-telescope/telescope-project.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
    }
}
