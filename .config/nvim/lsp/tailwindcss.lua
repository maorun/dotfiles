-- local base_root_dir = require('lspconfig.lsp.tailwindcss').root_dir
return {
    settings = {
        classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
        classFunctions = { 'cn', 'tw', 'clsx', 'classNames' },
        -- https://github.com/tailwindlabs/tailwindcss-intellisense?tab=readme-ov-file#extension-settings
        tailwindCSS = {
            classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'classNames' },
            classFunctions = { 'tw', 'clsx', 'classNames' },
            showPixelEquivalents = false,
            experimental = {
                configFile = {
                    ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/techbook/tailwind.css'] =
                    '**/Techbook/**',
                    ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/bildkaufberater/tailwind.css'] =
                    '**/BildKaufberater/**',
                    ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/bild/tailwind.css'] = '**/Bild/**',
                    ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/computerbild/tailwind.css'] =
                    '**/ComputerBild/**',
                    ['/Users/mdriemel/repos/ac-steam/packages/tailwindcss/autobild/tailwind.css'] =
                    '**/AutoBild/**',
                    ['/Users/mdriemel/repos/ac-steam/packages/backend/app/tailwind.css'] = '**/backend/**',
                    ['./tailwind.css'] = '*',
                }
            }
        }
    },
}
