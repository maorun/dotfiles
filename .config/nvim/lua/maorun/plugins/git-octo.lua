return {
    'pwntester/octo.nvim',
    event = 'VimEnter',
    dependencies = {
        'folke/which-key.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    init = function()
        require "octo".setup()
        vim.g.octo_viewer = 'maorun'     -- https://github.com/pwntester/octo.nvim/issues/466

        local octoGroup = vim.api.nvim_create_augroup('Octo', {})
        function SquashMergeConfirm()
            vim.ui.select({ 'yes', 'no' }, {
                prompt = 'Merge Squash?',
                kind = 'ass'
            }, function(selected)
                if (selected == 'yes') then
                    local commands = require("octo.commands")
                    commands.merge_pr("squash")
                end
            end
            )
        end

        function RebaseMergeConfirm()
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
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>ppm", ':lua RebaseMergeConfirm()<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>ppn", ':lua SquashMergeConfirm()<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>ppc", ":Octo pr checks<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>pps",
                    ":%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2<cr>:nohlsearch<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rs", ":Octo review start<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rn", ":Octo review resume<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rd", ":Octo pr ready<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>pr", ":Octo thread resolve<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rq",
                    ":split | terminal grd " .. vim.fn.expand("%:t") .. "<cr>a",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<C-N>", ":Octo pr browser<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>sf",
                    ":%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2/<cr><C-l>",
                    { silent = true, noremap = true })
            end,
        })
        vim.api.nvim_create_autocmd('FileType', {
            group = octoGroup,
            pattern = 'octo_panel',
            callback = function()
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rs", ":Octo review submit<cr>",
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "<leader>rq", ":Octo review discard<cr>",
                    { silent = true, noremap = true })
            end,
        })

        local mappingListPlugin = require("maorun.mappingList")
        mappingListPlugin.init()
        local octoHelp = function()
            local mappings = require('octo.config').get_config().mappings
            local list = {}
            local k, v = next(mappings)
            while k do
                k, v = next(mappings, k)
                if (k ~= nil) then
                    for key, value in next, v do
                        -- print(vim.inspect(value))
                        table.insert(list, k .. " : " .. value.lhs .. " => " .. value.desc)
                    end
                end
            end
            mappingListPlugin.mappingList {
                title = "octo",
                list = list
            }
        end
        local wk = require("which-key")
        wk.register({
            h = {
                name = 'Help',
                o = { octoHelp, "octo", noremap = true },
            },
            t = {
                name = "Telescope",
                o = {
                    name = "Octo",
                    a = { ':Octo actions<cr>', "Octo actions", noremap = true },
                    c = { ':Octo pr create draft<cr>', "create PR draft", noremap = true },

                    k = {
                        function()
                            mappingListPlugin.mappingList {
                                title = "octo",
                                list = {
                                    'maorun/zinszins-simulation',
                                    'maorun/code-stats',
                                    'maorun/snyk.nvim',
                                    'spring-media/ac-steam',
                                    'spring-media/ac-steam-flux',
                                },
                                action = function(value)
                                    vim.cmd('Octo pr list ' .. value)
                                end
                            }
                        end,
                        "list pr of a list of repos",
                        noremap = true
                    },
                    l = { ':Octo pr list<cr>', "list PR", noremap = true },
                    p = { ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", "should be keybind of tp fur Project", noremap = true },
                    h = { octoHelp, "help - mapping", noremap = true },
                },
            },
        }, { prefix = "<leader>" })
    end
}
