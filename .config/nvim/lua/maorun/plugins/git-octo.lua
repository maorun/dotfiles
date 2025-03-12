return {
    'pwntester/octo.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    init = function()
        require 'octo'.setup()
        vim.g.octo_viewer = 'maorun' -- https://github.com/pwntester/octo.nvim/issues/466

        local octoGroup = vim.api.nvim_create_augroup('Octo', {})
        function SquashMergeConfirm()
            vim.ui.select({ 'yes', 'no' }, {
                prompt = 'Merge Squash?',
                kind = 'ass'
            }, function(selected)
                if (selected == 'yes') then
                    local commands = require('octo.commands')
                    commands.merge_pr('squash')
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
                    local commands = require('octo.commands')
                    commands.merge_pr('rebase')
                end
            end
            )
        end

        function DismissReview()
            vim.cmd.split()
            vim.cmd.terminal('grd ' .. vim.fn.expand('%:t'))
            -- ':split | terminal grd "%:t"<cr>a',
        end

        vim.api.nvim_create_autocmd('FileType', {
            group = octoGroup,
            pattern = 'octo',
            callback = function()
                vim.api.nvim_buf_set_keymap(0, 'i', '@', '@<C-x><C-o>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'i', '#', '#<C-x><C-o>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ppm', ':lua RebaseMergeConfirm()<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ppn', ':lua SquashMergeConfirm()<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ppc', ':Octo pr checks<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pps',
                    ':%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2<cr>:nohlsearch<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rs', ':Octo review start<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rn', ':Octo review resume<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rd', ':Octo pr ready<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pr', ':Octo thread resolve<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rq',
                    ':split | terminal grd ' .. vim.fn.expand('%:t') .. '<cr>a',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<C-N>', ':Octo pr browser<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>sf',
                    ':%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2/<cr><C-l>',
                    { silent = true, noremap = true })
            end,
        })
        vim.api.nvim_create_autocmd('FileType', {
            group = octoGroup,
            pattern = 'octo_panel',
            callback = function()
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rs', ':Octo review submit<cr>',
                    { silent = true, noremap = true })
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rq', ':Octo review discard<cr>',
                    { silent = true, noremap = true })
            end,
        })
    end,
    keys = {
        { '<leader>toa', ':Octo actions<cr>',         desc = 'Octo actions',    remap = false },
        { '<leader>toc', ':Octo pr create draft<cr>', desc = 'create PR draft', remap = false },
        {
            '<leader>tok',
            function()
                local mappingListPlugin = require('maorun.mappingList')
                mappingListPlugin.init()
                mappingListPlugin.mappingList {
                    title = 'octo',
                    list = {
                        'maorun/code-stats',
                        'maorun/snyk.nvim',
                        'spring-media/ac-steam',
                        'spring-media/maps-setup-hh-flux-cd',
                        'spring-media/ac-steam-flux',
                    },
                    action = function(value)
                        vim.cmd('Octo pr list ' .. value)
                    end
                }
            end,
            desc = 'list pr of a list of repos',
            remap = false
        },
        { '<leader>tol', ':Octo pr list<cr>',                                                               desc = 'list PR',                             remap = false },
        { '<leader>top', ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<cr>", desc = 'should be keybind of tp fur Project', remap = false },
    }
}
