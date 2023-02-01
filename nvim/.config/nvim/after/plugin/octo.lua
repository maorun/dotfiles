local octoGroup = vim.api.nvim_create_augroup('Octo', {})
function rebaseMergeConfirm()
    vim.ui.select({ 'yes', 'no' }, {
        prompt = 'Merge Rebase?',
        kind = 'ass'
    }, function(selected)
            if (selected == 'yes') then
                local commands = require("octo.commands")
                commands.merge_pr("rebase")
            end
        end
    )
end
vim.api.nvim_create_autocmd('FileType', {
    group = octoGroup,
    pattern = 'octo',
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "i", "@", "@<C-x><C-o>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "i", "#", "#<C-x><C-o>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>ppm", ':lua rebaseMergeConfirm()<cr>', { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>ppc", ":Octo pr checks<cr>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>rs", ":Octo review start<cr>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>rn", ":Octo review resume<cr>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>rd", ":Octo pr ready<cr>", { silent = true, noremap = true })
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    group = octoGroup,
    pattern =  'octo_panel' ,
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>rs", ":Octo review submit<cr>", { silent = true, noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>rq", ":Octo review discard<cr>", { silent = true, noremap = true })
    end,
})

local wk = require("which-key")
wk.register({
    t = {
        name = "Telescope",
        o = {
            name = "Octo",
            a = { ':Octo actions<cr>', "Octo actions", noremap = true },
            c = { ':Octo pr create draft<cr>', "create PR draft", noremap = true },

            k = { function()
                local mappingListPlugin = require("maorun.telescope.mappingList")
                mappingListPlugin.init()
                mappingListPlugin.mappingList {
                    title = "octo",
                    list = {
                        'spring-media/ac-steam',
                        'spring-media/ac-steam-flux',
                        },
                    action = function(value)
                        vim.cmd('Octo pr list ' .. value)
                    end
                }
            end, "help", noremap = true },
            l = { ':Octo pr list<cr>', "list PR", noremap = true },
            p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "should be keybind of tp fur Project", noremap = true },
            h = { function()
                local mappings = require('octo.config').get_config().mappings
                local list = {}
                local k, v = next( mappings )
                while k do
                    k, v = next( mappings, k )
                    if (k ~= nil) then
                        for key, value in next, v do
                            -- print(vim.inspect(value))
                            table.insert(list, k .. " : " .. value.lhs .. " => " .. value.desc)

                        end
                    end
                end
                local mappingListPlugin = require("maorun.telescope.mappingList")
                mappingListPlugin.init()
                mappingListPlugin.mappingList {
                    title = "octo",
                    list = list
                }
            end, "help", noremap = true },
            },
    },
}, { prefix = "<leader>" })
