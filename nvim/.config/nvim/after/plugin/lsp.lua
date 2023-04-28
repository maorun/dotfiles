local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local wk = require("which-key")

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- buf_set_keymap('i', '<C-Space>', '<c-x><c-o>', {noremap = true})

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.register({
        l = {
            name = "LSP",
            g = {
                name = "Goto",
                D = {':lua vim.lsp.buf.declaration()<CR>', 'Declaration', noremap = true},
                d = {':lua vim.lsp.buf.definition()<CR>', 'Definition', noremap = true},
                i = {':lua vim.lsp.buf.implementation()<CR>', 'Implementaion', noremap = true},
                r = {':lua require("telescope.builtin").lsp_references()<CR>', 'References', noremap = true},
                t = {':lua vim.lsp.buf.type_definition()<CR>', 'Type definition', noremap = true},
            },
            k = {':lua vim.lsp.buf.hover()<CR>', 'Hover', noremap = true},
            ['<C-k>'] = {':lua vim.lsp.buf.signature_help()<CR>', 'Signature help', noremap = true},
            r = {':lua vim.lsp.buf.rename()<CR>', 'rename', noremap = true},
            c = {':lua vim.lsp.buf.code_action()<CR>', 'code-action', noremap = true},
            f = {':lua vim.lsp.buf.format { async = true }<CR>', 'format', noremap = true},
        },
    }, { silent=true, prefix = '<leader>' })
    wk.register({
        g = {
            name = "Goto",
            D = {':lua vim.lsp.buf.declaration()<CR>', 'Declaration', noremap = true},
            d = {':lua vim.lsp.buf.definition()<CR>', 'Definition', noremap = true},
            i = {':lua vim.lsp.buf.implementation()<CR>', 'Implementaion', noremap = true},
            f = {':lua require("telescope.builtin").lsp_references()<CR>', 'References', noremap = true},
            y = {':lua vim.lsp.buf.type_definition()<CR>', 'Type definition', noremap = true},
        },
    }, { silent = true})
end
-- Diagnostics mapping (should also available without LSP)
wk.register({
    l = {
        name = "LSP",
        K = {':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<cr>', 'open_float', noremap = true},
        q = {':lua vim.diagnostic.setloclist()<cr>', 'show diagnostics', noremap = true},
    },
}, { silent=true, prefix = '<leader>' })
wk.register({
    g = {
        name = "Goto",
        ['['] = {':lua vim.diagnostic.goto_prev()<CR>', 'next diagnostic', noremap = true},
        [']'] = {':lua vim.diagnostic.goto_next()<CR>', 'prev diagnostic', noremap = true},
    },
}, { silent = true})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 
    -- 'vimls',
    'tsserver', 'graphql', 'tailwindcss', 'phpactor', 'sqlls', 'eslint' }

local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

local forattingAuGroup = vim.api.nvim_create_augroup('formatting', {})
-- vim.api.nvim_create_autocmd('BufWritePre', {
--     group = forattingAuGroup,
--     pattern = {'*.tsx','*.ts','*.jsx','*.js'},
--     command = 'lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})',
-- })
local signcolumnAuGroup = vim.api.nvim_create_augroup('signcolumn', {})
vim.api.nvim_create_autocmd('FileType', {
    group = signcolumnAuGroup,
    pattern = {'typescript','javascript','javascriptreact','typescriptreact'},
    command = 'setlocal signcolumn=yes',
})

local border = {
            { "╔" , "LspFloatWinBorder" },
            { "═" , "LspFloatWinBorder" },
            { "╗" , "LspFloatWinBorder" },
            { "║" , "LspFloatWinBorder" },
            { "╝" , "LspFloatWinBorder" },
            { "═" , "LspFloatWinBorder" },
            { "╚" , "LspFloatWinBorder" },
            { "║" , "LspFloatWinBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  -- I would love to retrieve the severity level just here in order to modify opts.border
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Show source in diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})
