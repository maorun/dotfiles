local cmp = require'cmp'
cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<c-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", vim_item.kind, entry.source.name)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                buffer = "[Buf]",
                vsnip = "[Vsnip]",
                luasnip = "[LuaSnip]",
                treesitter = "[Treesitter]",
                copilot = "[Copilot]",
                cmp_tabnine = "[Tabnine]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
        { name = 'copilot' },
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
    }
}

