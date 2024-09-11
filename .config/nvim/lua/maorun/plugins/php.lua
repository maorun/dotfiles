return {
    {
        enabled = false,
        'phpactor/phpactor',
        build = "composer install --no-dev -o",
        version = '*',
        ft = 'php',
        init = function()
            vim.cmd "autocmd FileType php setlocal updatetime=2000"
        end
    }
}
