vim.filetype.add({
    extension = {
        mchat = 'mchat',
    }
})

local hf = require('model.providers.huggingface')
local openai = require('model.providers.openai')
local starterPrompts = require('model.prompts.starters')
local prompts = vim.tbl_extend('force', starterPrompts, {
    commit = {
        provider = openai,
        mode = require('model').mode.REPLACE,
        builder = function()
            local git_diff = vim.fn.system {'git', 'diff', '--staged'}

            if not git_diff:match('^diff') then
                error('Git error:\n' .. git_diff)
            end

            return {
                messages = {
                    {
                        role = 'user',
                        content = 'Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. Try to stay below 80 characters total. Staged git diff: ```\n' .. git_diff .. '\n```. After an additional newline, add a short description in 1 to 4 sentences of WHY the changes are done after the commit message. Don\'t start it with "This commit", just describe the changes. Use the present tense. Lines must not be longer than 74 characters.'
                    }
                }
            }
        end,
    }
})


local chats = vim.tbl_extend('force', require('model.prompts.chats') , {
    review = {
        provider = require('model.providers.ollama'),
        system = 'You are an expert programmer that gives constructive feedback. Review the changes in the user\'s git diff. don\'t describe what the user has done. Suggest some improvements if you find some. you should answer in german.',
        params = {
            model = 'starling-lm'
        },
        create = function()
            local git_diff = vim.fn.system {'git', 'diff', '--staged'}

            if not git_diff:match('^diff') then
                error('Git error:\n' .. git_diff)
            end

            return git_diff
        end,
        run = require('model.format.starling').chat
    }
})

require('model').setup({
    default_prompt= hf.default_prompt,
    chats = chats,
    prompts= prompts,
})

local augroup = vim.api.nvim_create_augroup("ai_model", {})
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "mchat",
    command = "nnoremap <silent><buffer> <leader>w :Mchat<cr>",
})
