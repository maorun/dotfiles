return {
    'pwntester/octo.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require 'octo'.setup({
            mappings = {
                file_panel = {
                    toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
                }
            }
        })
        vim.g.octo_viewer = 'maorun' -- https://github.com/pwntester/octo.nvim/issues/466

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

        function DismissReview()
            vim.cmd.split()
            vim.cmd.terminal('grd ' .. vim.fn.expand('%:t'))
            -- ':split | terminal grd "%:t"<cr>a',
        end
    end,
}
