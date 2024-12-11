local promptChecker =
'I want you to act as a prompt checker which checks a given prompt. the Answer should be short. rate the prompt an a scale from 1 to 10 how good the prompt is. You should not write why the prompt is bad or could be better. If the prompt is 10, just say "10" otherwise give a better version (a 10) of the prompt and rate this prompt. Start again with "I want you to act as a ".'

local modelName = 'deepseek-coder-v2'
-- codestral
-- codellama
-- qwen2.5-coder:32b
local ollamaDefaults = {
    provider = require('model.providers.ollama'),
    params = {
        model = modelName,
    },
    run = require('model.format.starling').chat
}
            local chats = vim.tbl_extend('force', require('model.prompts.chats'), {
            })
return {
    ['Prompt checker'] = vim.tbl_extend('force', ollamaDefaults, {
        system = promptChecker,
        create = function(input, context)
            return 'Prompt:' .. (context.selection and input or '')
        end,
    }),
    -- ['Prompt generator'] = {
    --     system = 'I want you to act as a guidance to create a prompt which defines a role for an AI. This prompt should be as short as possible. The prompt should start with "I want you to act as a ". Check the prompt on a scale from 1 to 10 and create a prompt which goes to 10'

    -- },
    -- productManager = {
    --     provider = require('model.providers.ollama'),
    --     system = productManager .. asksQuestions,
    --     params = {
    --         model = modelName,
    --     },
    --     create = function(input, context)
    --         return 'Topic: ' ..
    --             (context.selection and input or '')
    --     end,
    --     run = require('model.format.starling').chat
    -- },
    productManagerStories = {
        provider = require('model.providers.ollama'),
        system =
        'I want you to act as a Product Owner. You write stories based on the user requirements i gave you.',
        params = {
            model = modelName,
        },
        create = function(input, context)
            return context.selection and input or ''
        end,
        run = require('model.format.starling').chat
    },
    describe = {
        provider = require('model.providers.ollama'),
        system =
        'You are an expert programmer that gives describe the code in english given to you',
        params = {
            model = modelName,
        },
        create = function(input, context)
            return context.selection and input or ''
        end,
        run = require('model.format.starling').chat
    },
    review = {
        provider = require('model.providers.ollama'),
        system =
        'You are an expert programmer that gives constructive feedback. Review the changes in the user\'s git diff. don\'t describe what the user has done. Suggest some improvements if you find some.',
        params = {
            model = modelName,
        },
        create = function()
            local cwd = vim.fn.expand('%:h:h')
            local git_diff = vim.fn.system { 'git', '-C', cwd, 'diff', '--staged', '-U0' }

            if not git_diff:match('^diff') then
                error('Git error:\n' .. git_diff)
            end

            return git_diff
        end,
        run = require('model.format.starling').chat
    }
}
