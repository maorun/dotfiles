return {
    {
        'maorun/code-stats.nvim',
        dependencies = {
            {
                -- 'maorun/dotfiles-personal',
                dir = '~/dotfiles/personal',
                init = function()
                    require('maorun.personal')
                end,
            },
        },
        init = function()
            require('maorun.personal') -- for the auth-key
            require('maorun.code-stats').setup()
        end
    },
}
