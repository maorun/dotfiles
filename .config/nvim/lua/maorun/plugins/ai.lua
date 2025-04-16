return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        init = function()
            require('copilot').setup({
                suggestion = {
                    -- auto_trigger = true,
                    keymap = {
                        next = '<C-l>',
                        prev = '<C-h>',
                        accept = '<C-;>',
                    }
                },
                -- should_attach = function(_, bufname)
                --     if string.match(bufname, "env") then
                --         return false
                --     end

                --     return true
                -- end
            })
        end,
    },
}
