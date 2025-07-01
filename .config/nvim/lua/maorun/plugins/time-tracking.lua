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
                hoursPerWeekday = {
                    Monday = 8,
                    Tuesday = 8,
                    Wednesday = 8,
                    Thursday = 7,
                    Friday = 5,
                },

            })
        end
    } }
