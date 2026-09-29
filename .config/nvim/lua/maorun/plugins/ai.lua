return {
    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
        },
        keys = {
            {
                "<s-tab>",
                function()
                    -- if there is a previous edit, jump to it, otherwise apply it if any
                    if not require("sidekick").pes_jump_or_apply() then
                        return "<S-Tab>" -- fallback to normal shift-tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Previous Edit Suggestion",
            },
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                mode = { "n", "x", "i", "t" },
                desc = "Sidekick Switch Focus",
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle({ focus = true })
                end,
                desc = "Sidekick Toggle CLI",
                mode = { "n", "v" },
            },
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "cursor", focus = true })
                end,
                desc = "Sidekick Claude Toggle",
                mode = { "n", "v" },
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").select_prompt()
                end,
                desc = "Sidekick Ask Prompt",
                mode = { "n", "v" },
            },
        },
    },
    {
        'ravitemer/mcphub.nvim',
        cmd = 'MCPHub',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        build = 'npm install -g mcp-hub@4.2.1',
        config = function()
            local token_path = vim.fs.joinpath(
                vim.env.HOME,
                '.rovodev',
                'services',
                'gbrain',
                'rovodev.token'
            )
            if vim.fn.filereadable(token_path) == 1 then
                local token = vim.trim(table.concat(vim.fn.readfile(token_path), '\n'))
                if token ~= '' then
                    vim.env.GBRAIN_ROVODEV_TOKEN = token
                end
            end
            require('mcphub').setup()
        end,
    },
}
