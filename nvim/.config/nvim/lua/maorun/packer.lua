local wk = require("which-key")

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

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime'
    }

    -- Speed up loading Lua modules in Neovim to improve startup time.
    use {
        'lewis6991/impatient.nvim',
        config = function()
            require('impatient')
        end
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/vim-vsnip'
        },
        config = function ()
            require('maorun.plugin-config.cmp')
        end
    }

    use {
        'zbirenbaum/copilot-cmp',
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

    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope-project.nvim',
        requires = { 
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-file-browser.nvim'
        },
        config = function()
            require'telescope'.load_extension('project')
        end
    }
    use { -- google keep
        'stevearc/gkeep.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
        },
        run = ':UpdateRemotePlugins',
        config = function()
            require('telescope').load_extension('gkeep')
            local keepNote = vim.api.nvim_create_augroup("GoogleKeepNote", {})
            vim.api.nvim_create_autocmd("FileType", {
                group = keepNote,
                pattern = "GoogleKeepNote,GoogleKeepList",
                command = "set number relativenumber",
            })
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
            { 'BurntSushi/ripgrep' }, -- for live_grep and find_files
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
            require('telescope').load_extension('coc')
        end,
    }
    use { 
        disable = false,
        'nvim-telescope/telescope-github.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('telescope').load_extension('gh')
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
    --  use 'nvim-treesitter/playground'

    use {
        'neovim/nvim-lspconfig',
        config = function()
        end,
    }

    use {
        'MunifTanjim/prettier.nvim',
        after = { 'nvim-lspconfig' },
        requires = {
            'neovim/nvim-lspconfig',
            {
                'jose-elias-alvarez/null-ls.nvim',
                config = function()
                    local null_ls = require("null-ls")

                    null_ls.setup({
                        sources = { 
                            null_ls.builtins.formatting.prettier,
                            null_ls.builtins.formatting.prettier_eslint,
                        },
                    })
                end

            }
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
            require("copilot").setup({
                suggestion = {
                    -- auto_trigger = true,
                    keymap = {
                        accept = "<Tab>",
                        next = "<C-n>",
                        prev = "<C-p>",
                    }
                }
            })
        end,
    }

    use {
        'preservim/nerdtree',
        config = function()
            require('maorun.plugin-config.nerdtree')
        end
    }

    use {
        'nvim-telescope/telescope-file-browser.nvim',
        requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require('maorun.plugin-config.telescope-file-browser')
        end
    }

    --  use 'junegunn/vim-peekaboo'

    -- Vim HardTime
    --  use 'takac/vim-hardtime'

    use 'justinmk/vim-sneak' -- replace s with search
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
            local fugitiveAuGroup = vim.api.nvim_create_augroup("user_fugitive", {})
            vim.api.nvim_create_autocmd("BufReadPost", {
                group = fugitiveAuGroup,
                pattern = "fugitive://*",
                command = "set bufhidden=delete",
            })
        end,
    }
    use {
        'rbong/vim-flog', -- Git-Tree
        cmd = 'Flogsplit',
    }

    use {
        'tpope/vim-dadbod', -- Database
        requires = {
            {
                'kristijanhusak/vim-dadbod-ui', -- Database-UI
                cmd = 'DBUI'
            }
        },
        cmd = 'DBUI',
        config = function ()
            local dbAuGroup = vim.api.nvim_create_augroup("user_db", {})
            vim.api.nvim_create_autocmd("FileType", {
                group = dbAuGroup,
                pattern = "dbout",
                command = "setlocal nofoldenable",
            })
            vim.api.nvim_create_autocmd("User", {
                group = dbAuGroup,
                pattern = "DBUIOpened",
                command = "setlocal relativenumber number",
            })
        end,
    }
    use 'vim-scripts/ReplaceWithRegister' -- replace with register - gr

    use { -- git-sign
        -- disable = true, -- startup-time-consuming
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup {
                current_line_blame = true,
            }
        end
    }

    use {
        disable = true,
        'neoclide/coc.nvim',
        branch= 'release',
        config= function()
            -- wk.register({
            --     ["<C-SPACE>"] = {'coc#refresh()', noremap = true },
            --     ["<tab>"] = {'coc#pum#visible() ? coc#pum#confirm() : "<tab>"', noremap = true },
            -- }, {mode = 'i', expr = true })
            vim.cmd [[
     inoremap <silent><expr> <c-space> coc#refresh()
     inoremap <silent><expr> <s-tab> coc#pum#visible() ? coc#pum#confirm() : "\<s-tab>"

    augroup Cursor
    autocmd!
    " autocmd CursorHold * silent call CocActionAsync('highlight')
    "    autocmd CursorHoldI * :call <SID>show_hover_doc()
    "    autocmd CursorHold * :call <SID>show_hover_doc()
    augroup END

    highlight CocFloating ctermbg=black
    highlight CocMenuSel ctermbg=Grey guibg=DarkGrey

    function! ShowDocIfNoDiagnostic(args)
    if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    "      silent call CocActionAsync('doHover')
    endif
    endfunction

    function! s:show_hover_doc()
    " call ShowDocIfNoDiagnostic()
    call timer_start(500, 'ShowDocIfNoDiagnostic')
    endfunction
]]
            wk.register({
                c = {
                    name = "COC",
                    ["a"] = {"<Plug>(coc-codeaction)", "open coc", noremap = true},
                    -- Apply AutoFix to problem on the current line.
                    ["f"] = {"<Plug>(coc-fix-current)", "quickfix current problem", noremap = true },
                    ["n"] = {"<plug>(coc-diagnostic-next)", "next problem", noremap = true },
                    ["p"] = {"<Plug>(coc-diagnostic-prev)", "prev problem", noremap = true },
                    ["r"] = {"<Plug>(coc-rename)", "rename", noremap = true },
                    ["d"] = {"<Plug>(coc-definition)", "see definition", noremap = true },
                    ["s"] = {"<Plug>(coc-references)", "see references", noremap = true },
                    ["i"] = {"<Plug>(coc-implementation)", "goto implementations", noremap = true },
                },
            }, { prefix = "<leader>" })

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
            vim.api.nvim_create_autocmd('CmdlineEnter', {
                group = vim.api.nvim_create_augroup('Wilder', {}),
                once = true,
                pattern = '*',
                callback = function()
                    local wilder = require('wilder')
                    wilder.setup({modes = {':', '/', '?'}})
                    wilder.set_option('pipeline', {
                        wilder.branch(
                            wilder.cmdline_pipeline({
                                language = 'python',
                                fuzzy = 2,
                            }),
                            wilder.python_search_pipeline({
                                pattern = wilder.python_fuzzy_pattern({
                                    start_at_boundary = 0
                                }),
                                sorter = wilder.python_difflib_sorter(),
                                engine = 're',
                            })
                        )
                    })
                    wilder.set_option('renderer', wilder.popupmenu_renderer({
                        highlighter = wilder.basic_highlighter(),
                        separator = ' · ',
                        left = {' ', wilder.wildmenu_spinner(), ' '},
                        right = {' ', wilder.wildmenu_index()},
                    }))
                end,
            })
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
            wk.register({
                ["¡"] = {"<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "navigate to file 1", noremap = true},
                ["™"] = {"<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "navigate to file 2", noremap = true},
                ["£"] = {"<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "navigate to file 3", noremap = true},
                ["¢"] = {"<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "navigate to file 4", noremap = true},

            }, { silent=true, prefix = '' })
            wk.register({
                a = {":lua require('harpoon.mark').add_file()<cr>", "Add file to mark", noremap = true},
            }, { silent=true, prefix = '<leader>' })
            require("telescope").load_extension('harpoon')
        end,
    }

    -- testing
    use {
        'vim-test/vim-test',
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
        disable = true,
        'ThePrimeagen/refactoring.nvim',
        config = function()
            require('refactoring').setup({})
        end
    }

    use {'kshenoy/vim-signature'} -- show marks

    use({
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup({
                keymaps = {
                    submit = "<C-s>"
                },
            })
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

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
