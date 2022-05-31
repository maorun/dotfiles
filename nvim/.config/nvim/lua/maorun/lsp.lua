local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

local lsp = require('lspconfig')
-- local bin_name = 'sonar-scanner'
-- local cmd = { bin_name }
-- if not configs.sonarlint then
--     configs.sonarlint = {
--         default_config = {
--             cmd = cmd;
--             filetypes = {'typescriptreact'};
--                 settings = {
--                 };
--                 root_dir = function(fname)
--                     return util.root_pattern 'sonar-project.properties'(fname)
--                 end;
--                 on_attach = function(_)
--                     print 'sonar-scanner attached'
--                 end;
--             };
--         }
-- end
-- lsp.sonarlint.setup({})

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local wk = require("which-key")
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
            K = {':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<cr>', 'open_float', noremap = true},
            ['<C-k>'] = {':lua vim.lsp.buf.signature_help()<CR>', 'Signature help', noremap = true},
            w = {
                name = "LSP-workspace",
                a = {':lua vim.lsp.buf.add_workspace_folder()<CR>', 'add to lsp-workspace', noremap = true},
                r = {':lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove from lsp-workspace', noremap = true},
                l = {':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'list lsp-workspace', noremap = true},
            },
            r = {':lua vim.lsp.buf.rename()<CR>', 'rename', noremap = true},
            ['['] = {':lua vim.diagnostic.goto_prev()<CR>', 'next diagnostic', noremap = true},
            [']'] = {':lua vim.diagnostic.goto_next()<CR>', 'prev diagnostic', noremap = true},
            c = {':lua vim.lsp.buf.code_action()<CR>', 'code-action', noremap = true},
            q = {':lua vim.diagnostic.setloclist()<cr>', 'show diagnostics', noremap = true},
            f = {':lua vim.lsp.buf.formatting()<CR>', 'format', noremap = true},
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
            ['['] = {':lua vim.diagnostic.goto_prev()<CR>', 'next diagnostic', noremap = true},
            [']'] = {':lua vim.diagnostic.goto_next()<CR>', 'prev diagnostic', noremap = true},
        },
    }, { silent = true})
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 
    -- 'vimls',
    'tsserver', 'graphql', 'tailwindcss', 'phpactor', 'sqlls', 'eslint' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")

-- require'lspconfig'.sumneko_lua.setup {
--     on_attach = on_attach,
--     flags = {
--         debounce_text_changes = 150,
--     },
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--                 -- Setup your lua path
--                 path = runtime_path,
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = {'vim'},
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file("", true),
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }
local forattingAuGroup = vim.api.nvim_create_augroup('formatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
    group = forattingAuGroup,
    pattern = {'*.tsx','*.ts','*.jsx','*.js','*.php'},
    command = 'lua vim.lsp.buf.formatting()',
})
local signcolumnAuGroup = vim.api.nvim_create_augroup('signcolumn', {})
vim.api.nvim_create_autocmd('FileType', {
    group = signcolumnAuGroup,
    pattern = {'typescript','javascript','javascriptreact','typescriptreact'},
    command = 'setlocal signcolumn=yes',
})

-- local diagnosticAuGroup = vim.api.nvim_create_augroup('diagnostics', {})
-- vim.api.nvim_create_autocmd('CursorHold', {
--     group = diagnosticAuGroup,
--     pattern = '*',
--     callback = function()
--         if (vim.diagnostic.open_float(nil, {focus=false, scope="cursor"}) == nil) then
--             vim.lsp.buf.hover()
--         end
--     end
-- })

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

