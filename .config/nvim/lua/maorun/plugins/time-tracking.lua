return {
    {
        'maorun/timeTrack.nvim',
        dependencies = {
            'folke/which-key.nvim',
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
        init = function()
            require 'maorun.time'.setup()
            local wk = require('which-key')
            wk.register({
                t = {
                    t = {
                        name = 'Time',
                        s = { '<cmd>lua Time.TimeStop()<cr>', 'TimeStop', noremap = true },
                        p = { '<cmd>lua Time.TimePause()<cr>', 'TimePause', noremap = true },
                        r = { '<cmd>lua Time.TimeResume()<cr>', 'TimeResume', noremap = true },
                    }
                },
            }, { prefix = '<leader>' })
        end
    } }
