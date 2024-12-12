local function esc(x)
    return (x:gsub('%%', '%%%%')
        :gsub('^%^', '%%^')
        :gsub('%$$', '%%$')
        :gsub('%(', '%%(')
        :gsub('%)', '%%)')
        :gsub('%.', '%%.')
        :gsub('%[', '%%[')
        :gsub('%]', '%%]')
        :gsub('%*', '%%*')
        :gsub('%+', '%%+')
        :gsub('%-', '%%-')
        :gsub('%?', '%%?'))
end

local source = {}

---Return the keyword pattern for triggering completion (optional).
function source:get_keyword_pattern()
    return "ACT-"
end
function source:get_trigger_characters()
    return { 'ACT' }
end

---Invoke completion (required).
function source:complete(params, callback)
    local input = params.context.cursor_before_line
    local r = vim.fn.system('jira c-ls')
    local t = {}
    r:gsub("[^\n]+\n",
        function(c)
            if c:match(esc(input)) then
                table.insert(t, {
                    label =    string.gsub(c, "(ACT%-%d+)%s+:%s+(.*)", "%1"),
                    cmp = {
                        kind_text =    string.gsub(c, "(ACT%-%d+)%s+:%s+(.*)", "%2")
                    },

                })
            end
        end
    )

    callback(t)

end

require('cmp').register_source('tickets', source)

return {}
