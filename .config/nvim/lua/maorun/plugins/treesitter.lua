return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local treesitter = require('nvim-treesitter')
            local parsers = {
                'graphql',
                'lua',
                'html',
                'javascript',
                'tsx',
                'typescript',
                'bash',
                'make',
                'markdown',
                'regex',
                'vim',
                'vimdoc',
                'yaml',
            }

            treesitter.setup()
            treesitter.install(parsers)

            -- mchat is a custom filetype, not an nvim-treesitter parser.
            vim.treesitter.language.register('markdown', 'mchat')

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
                callback = function()
                    if not pcall(vim.treesitter.start) then
                        return
                    end

                    local language = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
                    if vim.treesitter.query.get(language, 'indents') then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'VimEnter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        init = function()
            require 'treesitter-context'.setup {
                max_lines = 10,
            }
        end
    }
    -- , 'nvim-treesitter/playground'
}
