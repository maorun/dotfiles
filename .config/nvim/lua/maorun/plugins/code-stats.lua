return {
    {
        -- 'maorun/dotfiles-personal',
        dir = '~/dotfiles/personal',
        init = function()
            require('maorun.personal')
        end,
    },
    {
        'maorun/code-stats.nvim',
        -- enabled = false,
        init = function()
            require('maorun.personal') -- for the auth-key
            require('maorun.code-stats').setup()
        end
    },
}
