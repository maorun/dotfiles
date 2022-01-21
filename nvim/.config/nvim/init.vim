set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"lua","html","php","javascript", "tsx", "typescript","bash","make","markdown","regex","vim","yaml"},
    syncinstall = true,
    -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim
    highlight = {
        enable = true
    },
    textobjects = {
        select = {
            enable = true
        }
    },
    indent = {
        enable = true
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        }
      }
}
EOF

lua <<EOF
local lsp = require("lspconfig")
local bin_name = 'sonar-scanner'
local cmd = { bin_name }
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

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
EOF
" lua vim.diagnostic.open_float()

lua << EOF
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
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR><cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver', 'graphql', 'tailwindcss' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

"lua <<EOF
"require'nvim-treesitter.configs'.setup {
"    autotag = {
"    enable = true,
"    filetypes = {
"        "html",
"        "xml",
"        "javascript",
"        "javascriptreact",
"        "typescript",
"        "typescriptreact",
"        "vue",
"        "svelte"
"        }
"    },
"    matchup = {
"    enable = true,
"    },
"}
"EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
    matchup = {
        enable = true
    },
}
EOF

lua require('maorun.colors').init()

lua <<EOF
local actions = require('telescope.actions')
local action_layout = require("telescope.actions.layout")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-i>"] = actions.results_scrolling_up,
                ["<C-f>"] = actions.results_scrolling_down,
                ["<C-o>"] = action_layout.toggle_preview,
                ["<PageUp>"] = false,
                ["<PageDown>"] = false,
            },
        },
    },
    extensions = {
        gkeep = {
            find_method = "all_text",
            link_method = "title",
        },
    },
})
-- Load the extension
require('telescope').load_extension('gkeep')
vim.api.nvim_set_keymap('n', '<leader>tg', ":GkeepLogin marco.driemel@gmx.de<cr>:Telescope gkeep<cr>", {noremap = true})
EOF
lua vim.api.nvim_set_keymap('n', '<leader>gsl', ':Telescope git_stash<cr>', {noremap = true})

lua << EOF
    require("which-key").setup { }
EOF

" gelguy/wilder.nvim
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'language': 'python',
      \       'fuzzy': 2,
      \     }),
      \     wilder#python_search_pipeline({
      \       'pattern': wilder#python_fuzzy_pattern({
      \         'start_at_boundary': 0
      \       }),
      \       'sorter': wilder#python_difflib_sorter(),
      \       'engine': 're',
      \     }),
      \   ),
      \ ])
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'separator': ' · ',
      \ 'left': [' ', wilder#wildmenu_spinner(), ' '],
      \ 'right': [' ', wilder#wildmenu_index()],
      \ }))
