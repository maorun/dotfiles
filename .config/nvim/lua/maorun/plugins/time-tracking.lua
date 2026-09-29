return {
    {
        'maorun/timeTrack.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'rcarriga/nvim-notify',
        },
        config = function()
            require('maorun.time').setup({
                workModel = 'fourDayWeek',
            })
        end
    } }
