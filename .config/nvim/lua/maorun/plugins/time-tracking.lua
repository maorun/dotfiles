return {
    {
        'maorun/timeTrack.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- optional
            'nvim-lua/plenary.nvim',
            'rcarriga/nvim-notify',
        },
        init = function()
            require 'maorun.time'.setup({
                workModel = 'fourDayWeek',
            })
        end
    } }
