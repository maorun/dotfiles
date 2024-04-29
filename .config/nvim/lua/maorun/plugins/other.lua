return {
    {
        'rgroli/other.nvim',
        dependencies = {
            'folke/which-key.nvim',
        },
        event = 'VimEnter',
        init = function()
            require("other-nvim").setup({
                rememberBuffers = false,
                mappings = {
                    {
                        pattern = "(.*/)([^%.]+)(%..+)%.tsx$",
                        target = {
                            { target = "%1%2.tsx",           context = "component" },
                            { target = "%1%2.component.tsx", context = "component" },
                            { target = "%1%2.test.tsx",      context = "test" },
                            { target = "%1%2.stories.tsx",   context = "story" },
                            { target = "%1%2.mdx",           context = "MDX" },
                        }
                    },
                    {
                        pattern = "(.*/)([^%.]+)%.mdx$",
                        target = {
                            { target = "%1%2.tsx",           context = "component" },
                            { target = "%1%2.component.tsx", context = "component" },
                            { target = "%1%2.test.tsx",      context = "test" },
                            { target = "%1%2.stories.tsx",   context = "story" },
                            { target = "%1%2.mdx",           context = "MDX" },
                        }
                    },
                    {
                        pattern = "(.*/)([^%.]+)%.tsx$",
                        target = {
                            { target = "%1%2.tsx",           context = "component" },
                            { target = "%1%2.component.tsx", context = "component" },
                            { target = "%1%2.test.tsx",      context = "test" },
                            { target = "%1%2.stories.tsx",   context = "story" },
                            { target = "%1%2.mdx",           context = "MDX" },
                        }
                    }
                },
            })
            local wk = require("which-key")
            wk.register({
                t = {
                    n = {
                        name = ":Other",
                        n = { "<cmd>:Other<cr>", ":Other", noremap = true },
                        s = { "<cmd>:OtherSplit<cr>", ":OtherSplit", noremap = true },
                        v = { "<cmd>:OtherVSplit<cr>", ":OtherVSplit", noremap = true },
                    }
                },
            }, { prefix = "<leader>" })
        end
    }
}
