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
            local wk = require("which-key")
            wk.register({
                t = {
                    name = "Telescope",
                    f = { ":lua require('telescope.builtin').find_files()<cr>", "Find files", noremap = true },
                    r = { ":lua require('telescope.builtin').live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g', '!git/**'} }<cr>", "Live Grep", noremap = true },
                    p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "Project", noremap = true },
                    l = { ":lua require('telescope.builtin').oldfiles({cwd_only=true})<cr>", "Find last opened files", noremap = true },
                },
                g = {
                    name = "Git",
                    s = {
                        l = { ':Telescope git_stash<cr>', "Stash list", noremap = true },
                    },
                    g = { ":lua require'telescope.builtin'.git_files{}<cr>", "Git files", noremap = true },
                    b = {
                        name = "Branches",
                        a = { ":lua require'telescope.builtin'.git_branches()<cr>", "Git all branches", noremap = true },
                        b = { ":lua require'telescope.builtin'.git_branches({pattern = 'refs/heads'})<cr>", "Git lokal branches", noremap = true },
                        r = { ":lua require'telescope.builtin'.git_branches({pattern = 'refs/remotes'})<cr>", "Git remote branches", noremap = true },
                    },
                    h = {
                        name = "GitHub",
                        g = { ':lua require("telescope").extensions.gh.gist()<cr>', "Gist", noremap = true },
                    },
                },
                b = {
                    name = "Buffer",
                    b = { ':lua require("telescope.builtin").buffers()<cr>', "show Buffers", noremap = true },
                },
            }, { prefix = "<leader>" })
        end,
        dependencies = {
            'folke/which-key.nvim',
            {
                'BurntSushi/ripgrep',
                event = "VimEnter",
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
            require("telescope").load_extension "file_browser"

            local wk = require("which-key")

            wk.register({
                v = {
                    e = {
                        function()
                            require('telescope').extensions.file_browser.file_browser({
                                path = "~/dotfiles/",
                                prompt_title = "* dotfiles *",
                            })
                        end,
                        "find file in dotfiles",
                        noremap = true
                    },
                },
                n = {
                    name = "FileTree",
                    f = { ":Telescope file_browser path=%:p:h select_buffer=true<cr>", "current file", noremap = true },
                    t = { ":Telescope file_browser respect_gitignore=true<cr>", "open tree", noremap = true },
                },
            }, { prefix = "<leader>" })
        end
    },
    {
        event = "VimEnter",
        'nvim-telescope/telescope-project.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-file-browser.nvim'
        },
    }
}
