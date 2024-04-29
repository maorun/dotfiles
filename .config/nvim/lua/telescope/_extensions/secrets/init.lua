local has_wk, wk = pcall(require, 'which-key')
if not has_wk then
  error('This plugins requires folke/which-key.nvim')
end
local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local picker_opt = {
    folder = '.',
}

local displayer = entry_display.create({
    separator = " ",
    items = {
        { width = 80 },
        { remaining = true },
    },
})
local make_display = function(entry)
    return displayer({
        entry.description,
        entry.octal
    })
end

local secrets = function(opts)
    opts = vim.tbl_deep_extend("force", picker_opt, opts or {})
    local files = vim.fn.systemlist('find ' .. opts.folder .. ' -type f -name "*secret*.yaml"')
    local items = {}
    for key, value in pairs(files) do
        items[#items + 1] = {value}
    end
    pickers.new(opts, {
        prompt_title = "secrets",
        attach_mappings = function(propt_bufnr, map)
            actions.select_default:replace(function()
                local file = action_state.get_selected_entry().file
                local file_enc = file .. ".enc"
                actions.close(propt_bufnr)

                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_command('edit ' .. vim.api.nvim_buf_get_number(buf))

                local output = vim.fn.systemlist(string.format("sops -d %s", file))

                vim.api.nvim_buf_set_lines(0, 0, -1, true, output)

                vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
                vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
                vim.api.nvim_buf_set_option(0, 'swapfile', false)
                vim.api.nvim_buf_set_option(0, 'filetype', 'yaml')

                wk.register({
                    w = { function()
                        vim.api.nvim_command('silent write ' .. file_enc)
                        vim.fn.system('sops -e  --input-type yaml --output-type yaml ' .. file_enc .. ' > ' .. file)
                        vim.fn.system('rm ' .. file_enc)
                        vim.api.nvim_command('echom "saved to ' .. file .. '"')
                    end, 'save as encrypted', noremap = true },
                }, {
                        prefix = '<leader>',
                        buffer= 0
                    })

            end)
            return true
        end,
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    description = entry[1],
                    file = entry[1],


                    -- this is what we can fzf
                    ordinal = entry[1],
                }
            end
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

return telescope.register_extension({
    setup = function(ext_config, config)
        conf = vim.tbl_extend("force", conf, ext_config or {})
    end,
    exports = {
        secrets = secrets
    },
})
