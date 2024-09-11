return {
    {
        'maorun/timeTrack.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- optional
            'nvim-lua/plenary.nvim',
            {
                'rcarriga/nvim-notify',
                init = function()
                    vim.opt.termguicolors = true
                    vim.api.nvim_set_hl(0, 'NotifyBackground', { bg = '#000000', ctermbg = 0 })
                end
            }
        },
        keys = {
            { '<leader>tts', '<cmd>lua Time.TimeStop()<cr>',   desc = 'TimeStop',   noremap = true },
            { '<leader>ttp', '<cmd>lua Time.TimePause()<cr>',  desc = 'TimePause',  noremap = true },
            { '<leader>ttr', '<cmd>lua Time.TimeResume()<cr>', desc = 'TimeResume', noremap = true },
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
