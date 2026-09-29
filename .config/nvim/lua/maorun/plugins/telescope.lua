return {
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-project.nvim',
        },
        config = function()
            local actions = require('telescope.actions')
            local action_layout = require('telescope.actions.layout')
            local gitActions = require('maorun.plugin-config.telescope.gitActions').actions
            local telescope = require('telescope')

            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        '.cache/',
                        '.documented/',
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
                        'composer%.lock',
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
                                    local entry = action_state.get_selected_entry()
                                    if not entry then
                                        return
                                    end

                                    vim.v.oldfiles = vim.tbl_filter(function(file)
                                        return file ~= entry.value
                                    end, vim.v.oldfiles)

                                    actions._close(prompt_bufnr, true)
                                    telescope_builtin.oldfiles({ cwd_only = true })
                                end,
                            },
                        },
                    },
                    buffers = {
                        mappings = {
                            i = {
                                ['<C-d>'] = actions.delete_buffer,
                            },
                        },
                    },
                    git_stash = {
                        mappings = {
                            i = {
                                ['<C-d>'] = gitActions.git_delete_stash,
                                ['<C-f>'] = actions.preview_scrolling_down,
                            },
                        },
                    },
                    git_branches = {
                        mappings = {
                            i = {
                                ['<C-d>'] = gitActions.git_delete_branch + gitActions.showGitBranches,
                            },
                        },
                    },
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
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
                        end,
                    },
                },
            })

            telescope.load_extension('file_browser')
            telescope.load_extension('project')
        end,
    },
}
