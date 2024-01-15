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

    use {
        'maorun/dotfiles-personal',
        config = function()
            require('maorun.personal')
        end,
    }

    use {
        'L3MON4D3/LuaSnip',
        event = "VimEnter",
        run = "make install_jsregexp",
        config = function()
            require('maorun.plugin-config.luasnip')
        end
    }

    use {
        'hrsh7th/nvim-cmp',
        -- event = "VimEnter",
        config = function ()
            require('maorun.plugin-config.cmp')
        end
    }

    use {
        'hrsh7th/cmp-nvim-lua',
        requires = {
            'hrsh7th/nvim-cmp',
        }
    }

    use {
        'hrsh7th/cmp-buffer',
        requires = {
            'hrsh7th/nvim-cmp',
        }
    }

    use {
        'hrsh7th/cmp-omni',
        requires = {
            'hrsh7th/nvim-cmp',
        }
    }

    use {
        'saadparwaiz1/cmp_luasnip',
        event = "VimEnter",
        after = { 'LuaSnip', 'nvim-cmp' },
        requires = {
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
        }
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
        disable = true,
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
     -- use 'nvim-treesitter/playground'

    use {
        disable = true, -- because tsserver startet multiple times
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
        after = {
            'nvim-cmp',
        },
        requires = {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'mattn/efm-langserver',
            'folke/neodev.nvim', -- lsp for neovim
        },
        event = 'VimEnter',
        config = function()
            require('maorun.plugin-config.lsp')
        end,
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
            local ns = vim.api.nvim_create_namespace 'user.copilot'

            require('copilot.api').register_status_notification_handler(function(data)
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                if vim.fn.mode() == 'i' and data.status == 'InProgress' then
                    vim.api.nvim_buf_set_extmark(0, ns, vim.fn.line '.' - 1, 0, {
                        virt_text = { { ' 🤖Thinking...', 'Comment' } },
                        virt_text_pos = 'eol',
                        hl_mode = 'combine',
                    })
                end
            end)
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

    use {
        'smoka7/hop.nvim',
        config = function()
            local hop = require'hop'
            hop.setup { }
            vim.keymap.set('', 'S', function ()
                hop.hint_char2({ multi_windows = true })
            end, {remap = true})
            vim.keymap.set('', 's', function ()
                hop.hint_char2({ multi_windows = true })
            end, {remap = true})
        end
    }
    use 'tpope/vim-commentary' -- gcc
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
        cmd = 'DBUI',
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

    -- % matches also on if/while
    --  use 'andymass/vim-matchup'

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
        'echasnovski/mini.ai',
        config = function()
            require('mini.ai').setup()
        end
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

    use {
        disable = true,-- not used
        'kshenoy/vim-signature',
        event = 'VimEnter',
    } -- show marks

    use {
        "MunifTanjim/nui.nvim",
    }
    use {
        disable = true, -- only usable with openai
        "jackMort/ChatGPT.nvim",
        event = 'VimEnter',
        config = function()
            require('maorun.plugin-config.chatgpt')
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    }

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

    use {
        'gsuuon/model.nvim',
        config = function()
            require('maorun.plugin-config.ai-model')
        end
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
