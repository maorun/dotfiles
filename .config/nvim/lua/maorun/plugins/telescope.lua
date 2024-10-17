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
                        ".cache/",
                        ".next/",
                        'vendor/',
                        ".git/",
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
                    buffers = {
                        mappings = {
                            i = {
                                ["<c-d>"] = actions.delete_buffer,
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
                        auto_depth = true,
                    },
                    project = {
                        base_dirs = {
                            '~/repos',
                        },
                        hidden_files = true,
                        on_project_selected = function(prompt_bufnr)
                            local project_actions = require("telescope._extensions.project.actions")
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
        keys = {
                {'<leader>tf' ,  "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files", noremap = true },
                {'<leader>tr' ,  "<cmd>lua require('telescope.builtin').live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g', '!git/**'} }<cr>", desc = "Live Grep", noremap = true },
                {'<leader>tp' ,  "<cmd>lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", desc = "Project", noremap = true },
                {'<leader>tl' ,  "<cmd>lua require('telescope.builtin').oldfiles({cwd_only=true})<cr>", desc = "Find last opened files", noremap = true },

                {'<leader>gsl' ,  '<cmd>Telescope git_stash<cr>', desc = "Stash list", noremap = true },
                {'<leader>gg' ,  "<cmd>lua require'telescope.builtin'.git_files{}<cr>", desc = "Git files", noremap = true },
                {'<leader>gba' ,  "<cmd>lua require'telescope.builtin'.git_branches()<cr>", desc = "Git all branches", noremap = true },
                {'<leader>gbb' ,  "<cmd>lua require'telescope.builtin'.git_branches({pattern = 'refs/heads'})<cr>", desc = "Git lokal branches", noremap = true },
                {'<leader>gbr' ,  "<cmd>lua require'telescope.builtin'.git_branches({pattern = 'refs/remotes'})<cr>", desc = "Git remote branches", noremap = true },
                {'<leader>ghg' ,  '<cmd>lua require("telescope").extensions.gh.gist()<cr>', desc = "Gist", noremap = true },

                {'<leader>bb' ,  '<cmd>lua require("telescope.builtin").buffers()<cr>', desc = "show Buffers", noremap = true },
        },
        dependencies = {
            {
                'BurntSushi/ripgrep',
                event = "VimEnter",
            },                                 -- for live_grep and find_files
            'nvim-treesitter/nvim-treesitter', -- finder/preview
        },
    },
    {
        'maorun/telescope-file-browser.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require("telescope").load_extension "file_browser"
        end,
        keys = {
            {
                '<leader>ve',
                function()
                    require('telescope').extensions.file_browser.file_browser({
                        path = '~/dotfiles/',
                        prompt_title = '* dotfiles *',
                    })
                end,
                desc = 'find file in dotfiles',
                noremap = true
            },
            { '<leader>nf', ':Telescope file_browser follow_symlink=true path=%:p:h select_buffer=true<cr>', desc = 'current file', noremap = true },
            { '<leader>nt', ':Telescope file_browser respect_gitignore=true<cr>',                            desc = 'open tree',    noremap = true },
        },
    },
    {
        event = "VimEnter",
        'nvim-telescope/telescope-project.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'maorun/telescope-file-browser.nvim',
        },
    }
}
