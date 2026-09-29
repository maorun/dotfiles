return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            {
                'zbirenbaum/copilot-cmp',
                dependencies = {
                    'zbirenbaum/copilot.lua',
                },
                opts = {},
            },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
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
                    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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
                            luasnip = '[LuaSnip]',
                            copilot = '[Copilot]',
                            tickets = '[Ticket]',
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'tickets' },
                    { name = 'copilot', max_item_count = 5 },
                    { name = 'luasnip' },
                    { name = 'nvim_lua', max_item_count = 5 },
                },
            })
        end,
    },
}
