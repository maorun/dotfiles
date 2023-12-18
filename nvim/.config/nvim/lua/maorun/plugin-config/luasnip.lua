local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

ls.cleanup()

local function getResponse(text)
    local auth = "70166cda-1cd9-afd9-ec8b-f9f2137cd857:fx"
    local url = "https://api-free.deepl.com/v2/translate"
    local header = 'Authorization: DeepL-Auth-Key ' .. auth
    local contentType = 'Content-Type: application/json'
    local data = '{ "text": [ "' .. text .. '" ], "target_lang": "EN" }'
    local command = 'curl -s -X POST "' .. url .. '" --header "' .. header .. '" --header "' .. contentType .. '" --data \'' .. data .. '\''
    local result = vim.fn.system(command)
    local resultJson = vim.fn.json_decode(result)
    local resultText = resultJson.translations[1].text
    return resultText
end

local function requestdeeplink(position)
    return d(position, function(args)

        local theText = args[1][1]

        local nodes = {}
        table.insert(nodes, t(theText))
        -- table.insert(nodes, t(getResponse(args[1][1])))
        table.insert(nodes, t(vim.split(theText, " ")))
        return sn(nil, c(1, nodes))
        -- return args[1][1]
    end, {1})
end

ls.setup({
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = {{"choiceNode", "Comment"}},
            },
        },
    },
})

ls.add_snippets("all", {
    s("test", fmt([[
  test("{tr_desc}", {async}() => {{
    {begin}
  }})
  ]], {
            tr_desc = i(1),
            async = c(2, {t"async ", t""}),
            begin = i(0)
        }, {
            repeat_duplicates = true
        }))
})

vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})

-- vim.cmd[[inoremap <c-u> <cmd>lua require("luasnip.extras.select_choice")()<cr>]]

