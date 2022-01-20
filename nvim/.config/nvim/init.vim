set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"lua","html","php","javascript", "tsx", "typescript","bash","make","markdown","regex","vim","yaml"},
    syncinstall = true,
    highlight = {
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
        },
      }
}
EOF

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   matchup = {
"     enable = true,              -- mandatory, false will disable the whole extension
"   },
" }
" EOF

lua <<EOF
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local colors = function(opts)
  opts = opts or { 
    attach_mappings = function(propt_bugnr, map)
        map("i", "<cr>", function()
            print("SELECTED", vim.inspect(action_state.get_selected_entry()))
        end)
        return true
    end
  }
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = {
        { "red", "#ff0000" },
        { "green", "#00ff00" },
        { "blue", "#0000ff" },
      },
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[2],
        }
      end
    },
    sorter = conf.generic_sorter(opts)
  }):find()
end
require('telescope.builtin').foobar = colors
vim.api.nvim_set_keymap('n', '<leader>of', ":lua require('telescope.builtin').foobar()<cr>", {noremap = true})
EOF


lua <<EOF
require("telescope").setup({
  -- You can optionally configure the search method for each of the pickers.
  -- Below are the default values.
  extensions = {
    gkeep = {
      find_method = "all_text",
      link_method = "title",
    },
  },
})
-- Load the extension
require('telescope').load_extension('gkeep')
vim.api.nvim_set_keymap('n', '<leader>tg', ":Telescope gkeep<cr>", {noremap = true})
EOF

lua require('package-info').setup()
lua << EOF
    require("which-key").setup { }
EOF

augroup package.json
    au!
    au! BufRead package.json lua require('package-info').show()
augroup END

" gelguy/wilder.nvim
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'language': 'python',
      \       'fuzzy': 1,
      \     }),
      \     wilder#python_search_pipeline({
      \       'pattern': wilder#python_fuzzy_pattern(),
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

