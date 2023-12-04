local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    vim.opt.packpath =    vim.opt.packpath +  install_path
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local packer =require('packer')
packer.init({
    max_jobs = 50,
})

packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime'
    }

    -- Speed up loading Lua modules in Neovim to improve startup time.
    use {
        disable = true,
        'lewis6991/impatient.nvim',
        config = function()
            require('impatient')
        end
    }

    use {
        'maorun/dotfiles-personal',
        config = function()
            require('maorun.personal')
        end,
    }

    use {
        'hrsh7th/nvim-cmp',
        event = "VimEnter",
        requires = {
            {
                'hrsh7th/cmp-nvim-lsp',
            },
            {
                'hrsh7th/vim-vsnip', 
                event = "VimEnter",
            },
        },
        config = function ()
            require('maorun.plugin-config.cmp')
        end
    }

    use {
        'zbirenbaum/copilot-cmp',
        event = "InsertEnter",
        after = { "copilot.lua" },
        requires = {
            'zbirenbaum/copilot.lua'
        },
        config = function ()
            require("copilot_cmp").setup()
        end
    }
    use {
        'tzachar/cmp-tabnine',
        event = "InsertEnter",
        run='./install.sh',
        requires = 'hrsh7th/nvim-cmp',
        config = function ()
            require('maorun.plugin-config.tabnine')
        end
    }

    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {}
        end
    }

    use {
        "Exafunction/codeium.nvim",
        event = "InsertEnter",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
            })
        end
    }

    use 'nvim-lua/plenary.nvim'
    use {
        event = "VimEnter",
        'nvim-telescope/telescope-project.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-file-browser.nvim'
        },
        config = function()
        end
    }
    use { -- google keep
        'stevearc/gkeep.nvim',
        event = "VimEnter",
        requires = {
            'nvim-telescope/telescope.nvim',
        },
        run = ':UpdateRemotePlugins',
        config = function()
            require('maorun.plugin-config.gkeep')
        end
    }
    use {
        disable = true,
        'nvim-lua/popup.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

    use {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('maorun.plugin-config.telescope')
        end,
        requires = {
            { 
                'BurntSushi/ripgrep',
                event = "VimEnter",
            }, -- for live_grep and find_files
            'nvim-treesitter/nvim-treesitter', -- finder/preview
        },
    }
    use {
        disable = true,
        'fannheyward/telescope-coc.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
        end,
    }
    use {
        disable = false,
        'nvim-telescope/telescope-github.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            -- c-f browse modified files
            -- c-a approve
            -- c-e view details or diff
            -- c-r merge
            -- <cr> checkout
        end,
    }

    use {
        'nvim-tree/nvim-web-devicons',
        config = function()
            require'nvim-web-devicons'.setup {
                color_icons = true,
                default = true
            }
        end
    }

    use {
        'pwntester/octo.nvim',
        event = 'VimEnter',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function ()
            require"octo".setup()
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'nvim-treesitter/nvim-treesitter-context',
        event = "VimEnter",
        requires = {
            'nvim-treesitter/nvim-treesitter'
        },
        config = function()
            require'treesitter-context'.setup{
                max_lines = 10,
            }
        end
    }
    --  use 'nvim-treesitter/playground'

    use {
        disable = true,
        "SmiteshP/nvim-navbuddy",
        after = "nvim-lspconfig",
        requires = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim" -- Optional
        },
        config = function()
            vim.g.navbuddy_silence = 1
            require("nvim-navbuddy").setup({
                lsp = {
                    auto_attach = true,
                }
            })
            local wk = require("which-key")
            wk.register({
                n = {
                    v = { "<cmd>lua require('nvim-navbuddy').open()<cr>", ":Navbuddy", noremap = true},
                },
            }, { prefix = "<leader>"})
        end
    }

    use {
        'neovim/nvim-lspconfig',
        event = 'VimEnter',
        config = function()
            require('maorun.plugin-config.lsp')
        end,
    }

    use {
        'jose-elias-alvarez/null-ls.nvim',
        event = "VimEnter",
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                debug = true,
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.prettier_eslint,
                    -- null_ls.builtins.diagnostics.eslint,
                    -- null_ls.builtins.code_actions.eslint,
                    -- null_ls.builtins.code_actions.gitsigns,
                },
            })
        end

    }

    use {
        'MunifTanjim/prettier.nvim',
        after = { 'nvim-lspconfig' },
        opt = true,
        requires = {
            'neovim/nvim-lspconfig',
            'jose-elias-alvarez/null-ls.nvim',
        },
        config = function()
            local prettier = require("prettier")

            prettier.setup({
                bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "scss",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                },
            })
        end
    }

    use {
        'rafcamlet/nvim-luapad',
        cmd= 'Luapad'
    }

    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && npm install',
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    }

    use {
        disable = true,
        'github/copilot.vim',
    }
    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require('maorun.plugin-config.copilot')
        end,
    }

    use {
        'nvim-telescope/telescope-file-browser.nvim',
        after = {'telescope.nvim'},
        requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require('maorun.plugin-config.telescope-file-browser')
        end
    }

    --  use 'junegunn/vim-peekaboo'

    -- Vim HardTime
    --  use 'takac/vim-hardtime'

    use {
        'maorun/timeTracking.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            {
                'rcarriga/nvim-notify',
                config = function()
                    vim.opt.termguicolors = true
                    vim.api.nvim_set_hl(0, "NotifyBackground", { bg="#000000", ctermbg=0})
                end
            }
        },
        config = function()
            require'maorun.time'.setup()
        end
    }

    use 'justinmk/vim-sneak' -- replace s with search

    use {
        -- until https://github.com/phaazon/hop.nvim/pull/340
        'mistweaverco/hop.nvim',
        config = function()
            local hop = require'hop'
            hop.setup { }
            vim.keymap.set('', '<c-f>', function ()
                hop.hint_char2({ multi_windows = true })
            end, {remap = true})
        end
    }
    use 'tpope/vim-commentary' -- gcc
    use {
        disable= true,
        'tpope/vim-obsession', -- vim session
    }
    use 'tpope/vim-surround' -- add/delete/change surround

    -- autocomplete
    use {
        'phpactor/phpactor',
        run = "composer install --no-dev -o",
        tag = '*',
        ft = 'php',
    }
    --  use 'stephenway/postcss.vim'
    -- git plugins
    use 'tpope/vim-repeat' -- repeat all plugins with .
    use { -- Git
        'tpope/vim-fugitive',
        config = function()
            require('maorun.plugin-config.database')
        end,
    }
    use {
        'rbong/vim-flog', -- Git-Tree
        cmd = 'Flogsplit',
    }

    use {
        'kristijanhusak/vim-dadbod-ui', -- Database-UI
        requires = {
            'tpope/vim-dadbod'
        },
        after= {'vim-dadbod'}
    }

    use {
        'tpope/vim-dadbod', -- Database
        cmd = 'DBUI',
        config = function ()
            require('maorun.plugin-config.database')
        end,
    }
    use 'vim-scripts/ReplaceWithRegister' -- replace with register - gr

    use { -- git-sign
        -- disable = true, -- startup-time-consuming
        'lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('maorun.plugin-config.gitsigns')
        end
    }
    use {
        -- o -> old version
        -- O -> new version
        cmd = 'GitMessenger',
        'rhysd/git-messenger.vim',
        config = function()
            require('maorun.plugin-config.git-messenger')
        end
    }

    use {
        disable = true,
        'neoclide/coc.nvim',
        branch= 'release',
        config= function()
            require('maorun.plugin-config.coc')
        end,
        run = function()
            vim.cmd [[
            :CocInstall coc-html-css-support coc-tsserver coc-json coc-prettier coc-phpactor coc-phpls coc-tabnine coc-html
            ]]
        end,
        requires = {
            { 'neoclide/coc-tabnine' },
            { -- only with 12.22.9 ???
                'neoclide/coc-html',
                run= 'npm install'
            },
        }
        -- Plug('rodrigore/coc-tailwind-intellisense', {'do': 'npm install'})  -- only with node 16.X
        -- Plug('iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'})
    }

    --  use 'jwalton512/vim-blade' -- Blade-Template (Laravel 4+)

    -- % matches also on if/while
    --  use 'andymass/vim-matchup'
    -- graphql
    --  use 'jparise/vim-graphql'

    -- typescript
    --  use 'leafgarland/typescript-vim'
    -- Training
    --  use 'tjdevries/train.nvim'
    use {
        'ThePrimeagen/vim-be-good',
        cmd= 'VimBeGood'
    }
    -- Vim Script

    -- wildermenu for :e and /
    -- function! UpdateRemotePlugins(...)
    -- end
    use {
        'gelguy/wilder.nvim',
        config = function()
            require('maorun.plugin-config.wilder')
        end
    }

    -- css-color
    --  use 'ap/vim-css-color'

    -- multi-select
    --  use 'mg979/vim-visual-multi', {'branch': 'master'}
    -- TODO: LEARN IT

    --  use 'kana/vim-textobj-user'

    -- aa - around argument
    use {
        'wellle/targets.vim',
    }

    -- quick Filebrowsing
     use {
        disable = true,
        'ThePrimeagen/harpoon',
        config = function()
            require('maorun.plugin-config.harpoon')
        end,
    }

    -- testing
    use {
        'vim-test/vim-test',
        event = 'VimEnter',
        config = function()
            require('maorun.plugin-config.vim-test')
        end,
    }

    use {
        'maorun/snyk.nvim',
        run = 'npm install',
        disable = true,
        config = function()
            require('maorun.snyk').setup()
        end,
    }
    use {
        'maorun/code-stats.nvim',
        after = 'dotfiles-personal',
        config = function()
            require('maorun.code-stats').setup()
        end
    }

    -- varnish-syntax highlighting
    use {
        'varnishcache-friends/vim-varnish',
        ft = { "vcl" }
    }

    -- refactor
    use {
        -- disable = true,
        'ThePrimeagen/refactoring.nvim',
        event = 'VimEnter',
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        },
        config = function()
            require('maorun.plugin-config.refactor')
        end,
    }

    -- until https://github.com/ThePrimeagen/refactoring.nvim/pull/372
    use {
        'napmn/react-extract.nvim',
        event = 'VimEnter',
        requires = {
            'nvim-treesitter/nvim-treesitter',
            'folke/which-key.nvim',
        },
        config = function()
            require("react-extract").setup({
                ts_template_before = "export function [COMPONENT_NAME]([PROPERTIES]:{[TYPE_PROPERTIES]}) {\n"
                    .. "[INDENT]return (\n",

            })
            local wk = require("which-key")
            wk.register({
                r = {
                    name = "Refactor Component",
                    f = { "<cmd>lua require('react-extract').extract_to_new_file()<CR>", "Extract to new file" },
                    e = { "<cmd>lua require('react-extract').extract_to_current_file()<CR>", "Extract to current file" },
                },
            }, { prefix = "<leader>", mode = "v" })



        end
    }

    use {
        'kshenoy/vim-signature',
        event = 'VimEnter',
    } -- show marks

    use({
        disable = true,
        "jackMort/ChatGPT.nvim",
        config = function()
            require('maorun.plugin-config.chatgpt')
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

    use {
        'rgroli/other.nvim',
        event = 'VimEnter',
        config = function()
            require("other-nvim").setup({
                rememberBuffers = false,
                mappings = {
                    {
                        pattern = "(.*/)([^%.]+)(%..+)%.tsx$",
                        target = {
                            {target = "%1%2.tsx", context = "component" },
                            {target = "%1%2.component.tsx", context = "component" },
                            {target = "%1%2.test.tsx", context = "test" },
                            {target = "%1%2.stories.tsx", context = "story" },
                            {target = "%1%2.mdx", context = "MDX" },
                        }
                    },
                    {
                        pattern = "(.*/)([^%.]+)%.mdx$",
                        target = {
                            {target = "%1%2.tsx", context = "component" },
                            {target = "%1%2.component.tsx", context = "component" },
                            {target = "%1%2.test.tsx", context = "test" },
                            {target = "%1%2.stories.tsx", context = "story" },
                            {target = "%1%2.mdx", context = "MDX" },
                        }
                    },
                    {
                        pattern = "(.*/)([^%.]+)%.tsx$",
                        target = {
                            {target = "%1%2.tsx", context = "component" },
                            {target = "%1%2.component.tsx", context = "component" },
                            {target = "%1%2.test.tsx", context = "test" },
                            {target = "%1%2.stories.tsx", context = "story" },
                            {target = "%1%2.mdx", context = "MDX" },
                        }
                    }
                },
            })
            local wk = require("which-key")
            wk.register({
                t = {
                    n = {
                        name = ":Other",
                        n = { "<cmd>:Other<cr>", ":Other", noremap = true},
                        s = { "<cmd>:OtherSplit<cr>", ":OtherSplit", noremap = true},
                        v = { "<cmd>:OtherVSplit<cr>", ":OtherVSplit", noremap = true},
                    }
                },
            }, { prefix = "<leader>"})

        end
    }

    use {
        "folke/trouble.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerCompile
  augroup end
]])
