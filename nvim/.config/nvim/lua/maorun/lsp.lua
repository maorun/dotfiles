local lsp = require('lspconfig')
local bin_name = 'sonar-scanner'
local cmd = { bin_name }
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

if not configs.sonarlint then
    configs.sonarlint = {
        default_config = {
            cmd = cmd;
            filetypes = {'typescriptreact'};
                settings = {
                };
                root_dir = function(fname)
                    return util.root_pattern 'sonar-project.properties'(fname)
                end;
                on_attach = function(client)
                    print 'sonar-scanner attached'
                end;
            };
        }
end
-- lsp.sonarlint.setup({})

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ac', '<cmd>lua vim.diagnostic.goto_next()<CR><cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>cn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>cp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver', 'graphql', 'tailwindcss', 'phpactor', 'sqlls', 'eslint' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end
vim.cmd [[
    augroup eslint
        autocmd!
        autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
    augroup END
    augroup typescript
        autocmd!
        autocmd FileType typescriptreact setlocal signcolumn=yes
        autocmd FileType typescript setlocal signcolumn=yes
    augroup END
]]

vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

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

