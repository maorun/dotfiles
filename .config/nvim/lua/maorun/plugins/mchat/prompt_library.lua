local openai = require('model.providers.openai')

return {
    commit = {
        provider = openai,
        model = 'gpt-4o-mini',
        mode = require('model').mode.REPLACE,
        builder = function()
            local cwd = vim.fn.expand('%:h')
            local git_diff = vim.fn.system { 'git', '-C', cwd, 'diff', '--staged' }

            if not git_diff:match('^diff') then
                error('Git error:\n' .. git_diff)
            end

            return {
                messages = {
                    {
                        role = 'system',
                        content =
                            'Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Don\'t use ` in the response. Try to stay below 80 characters total. Staged git diff: ```\n' ..
                            git_diff ..
                            '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.'
                    }
                }
            }
        end,
    }
}
