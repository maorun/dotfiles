return {
    {
        'maorun/snyk.nvim',
        build = 'npm install',
        enabled = false,
        init = function()
            require('maorun.snyk').setup()
        end,
    } }
