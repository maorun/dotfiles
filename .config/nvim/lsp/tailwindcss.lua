local ac_steam_root = vim.fs.joinpath(vim.env.HOME, 'repos', 'ac-steam')

return {
    settings = {
        classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
        classFunctions = { 'cn', 'tw', 'clsx', 'classNames' },
        tailwindCSS = {
            classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
            classFunctions = { 'tw', 'clsx', 'classNames' },
            showPixelEquivalents = false,
            experimental = {
                configFile = {
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'tailwindcss', 'techbook', 'tailwind.css')] =
                    '**/Techbook/**',
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'tailwindcss', 'bildkaufberater', 'tailwind.css')] =
                    '**/BildKaufberater/**',
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'tailwindcss', 'bild', 'tailwind.css')] = '**/Bild/**',
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'tailwindcss', 'computerbild', 'tailwind.css')] =
                    '**/ComputerBild/**',
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'tailwindcss', 'autobild', 'tailwind.css')] =
                    '**/AutoBild/**',
                    [vim.fs.joinpath(ac_steam_root, 'packages', 'backend', 'app', 'tailwind.css')] = '**/backend/**',
                    ['./tailwind.css'] = '*',
                },
            },
        },
    },
}
