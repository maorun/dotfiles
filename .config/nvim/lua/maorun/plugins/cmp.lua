return {
    {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    {
        'hrsh7th/cmp-nvim-lua',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    {
        'hrsh7th/cmp-buffer',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    {
        'hrsh7th/cmp-omni',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    {
        'saadparwaiz1/cmp_luasnip',
        event = 'VimEnter',
        dependencies = {
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
        }
    },
    {
        'zbirenbaum/copilot-cmp',
        event = 'InsertEnter',
        dependencies = {
            'zbirenbaum/copilot.lua'
        },
        opts = {},
    },
    {
        'hrsh7th/nvim-cmp',
        -- event = "VimEnter",
        dependencies = {
            'L3MON4D3/LuaSnip'
        },
        init = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') ==
                    nil
            end

            local cmp = require 'cmp'

            cmp.setup {
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        local luasnip = require('luasnip')
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        local luasnip = require('luasnip')
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<CR>'] = cmp.mapping({
                        i = function(fallback)
                            if #cmp.get_entries() == 1 then
                                cmp.confirm({ select = true })
                            elseif cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),
                    ['<c-l>'] = cmp.mapping(function(fallback)
                        local luasnip = require('luasnip')
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<c-h>'] = cmp.mapping(function(fallback)
                        local luasnip = require('luasnip')
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<c-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<c-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = string.format('%s %s', vim_item.kind, entry.source.name)
                        vim_item.menu = ({
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[Lua]',
                            buffer = '[Buf]',
                            vsnip = '[Vsnip]',
                            luasnip = '[LuaSnip]',
                            treesitter = '[Treesitter]',
                            copilot = '[Copilot]',
                            codeium = '[Codeium]',
                            tickets = '[Ticket]'
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                performance = {
                    fetching_timeout = 1000,
                },
                sources = {
                    { name = 'nvim_lsp', },
                    { name = 'tickets', },
                    { name = 'copilot',  max_item_count = 5 },
                    { name = 'luasnip' },
                    { name = 'codeium',  max_item_count = 5 },
                    { name = 'nvim_lua', max_item_count = 5 },
                    { name = 'buffer',   max_item_count = 5 },
                    {
                        name = 'omni',
                        max_item_count = 5,
                        option = {
                            disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
                        }
                    },
                }
            }
        end
    },
}
