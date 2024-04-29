return {
    {
        'maorun/code-stats.nvim',
        dependencies = {
            {
                -- 'maorun/dotfiles-personal',
                dir = '~/real-dotfiles/personal',
                init = function()
                    require('maorun.personal')
                end,
            },
        },
        init = function()
            require('maorun.code-stats').setup()
        end
    },
}
