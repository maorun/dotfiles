require('maorun.personal') -- for the auth-key

vim.cmd [[
    function! RequestDeepl(text)
        let auth = g:deepl_api_key
        let url = "https://api-free.deepl.com/v2/translate"
        let header = 'Authorization: DeepL-Auth-Key ' .. auth
        let contentType = 'Content-Type: application/json'
        let data = '{ "text": [ "' .. a:text .. '" ], "target_lang": "EN" }'

        let command = 'curl -s -X POST "' .. url .. '" --header "' .. header .. '" --header "' .. contentType .. '" --data ' .. shellescape(data) .. ""

         let result = system(command)
         let resultJson = json_decode(result)
         return resultJson.translations[0].text
    endfunction

    function! DeepL(type)
        if a:type ==# 'char'
            execute "normal! `[v`]y"
            let response = RequestDeepl(@@)
            execute "normal! `<v`>c" .. (response)
            echom "translated c"
        elseif a:type ==# 'v'
            normal! `<v`>y
            let response = RequestDeepl(@@)
            execute "normal! `<v`>c" .. (response)
            echom "translated v"
        else
                " silent execute "normal! `[V`]\"+y"
            echom a:type ' - ' .. shellescape(@@)
            return
        endif
    endfunction

]]
