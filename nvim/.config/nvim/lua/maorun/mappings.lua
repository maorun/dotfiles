vim.g.mapleader = ' '

-- got to indention level {{{
vim.cmd [[
    function! s:indent_len(str)
        return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
    endfunction
    function! s:go_indent(times, dir)
        for _ in range(a:times)
            let l = line('.')
            let x = line('$')
            let i = s:indent_len(getline(l))
            let e = empty(getline(l))

            while l >= 1 && l <= x
                let line = getline(l + a:dir)
                let l += a:dir
                if s:indent_len(line) != i || empty(line) != e
                    break
                endif
            endwhile
            let l = min([max([1, l]), x])
            execute 'normal! '. l .'G^'
        endfor
    endfunction 

    nnoremap <silent> <leader>i :<c-u>call <SID>go_indent(v:count1, 1)<cr>
    nnoremap <silent> <leader>pi :<c-u>call <SID>go_indent(v:count1, -1)<cr>
]]
-- }}}

local wk = require("which-key")
newBuffer = function(args)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_command('edit ' .. vim.api.nvim_buf_get_number(buf))
    vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(0, 'swapfile', false)
    if (args ~= nil) then
        vim.api.nvim_buf_set_lines(0, 0, -1, true, args)
    end
end

function job(opts)
    local lines = {}
    opts = vim.tbl_deep_extend("keep", opts or {}, {
        silent = false,
        command = '',
        args =  {},
        interactive = false,
        on_stdout = function(error, data)
            table.insert(lines, data)
        end,
        on_stderr = function(error, data)
            table.insert(lines, data)
        end,
        on_exit = function(signal, failure)
            vim.schedule(function()
                vim.api.nvim_command('new')
                if (opts.silent ~= true) then
                    newBuffer(lines)
                end 
            end)
        end,
    })

    local Job = require'plenary.job'
    if (opts.silent ~= true) then
        print('start "' .. opts.command .. " " .. table.concat(opts.args,' ') .. '"')
    end
    Job:new(opts):start()
end

wk.register({
    ['<BS>'] = {":nohlsearch<cr>", "clear Search", noremap = true},
    ['<C-E>'] = {"<C-B>", "Scroll up"},
    g = {
        o = {"o<Esc>", "add a line below", noremap = true},
        O = {"O<Esc>", "add a line above", noremap = true},
    },
    n = {"nzzv"},
    N = {"Nzzv"},
    ["¡"] = {"<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "navigate to file 1", noremap = true},
    ["™"] = {"<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "navigate to file 2", noremap = true},
    ["£"] = {"<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "navigate to file 3", noremap = true},
    ["¢"] = {"<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "navigate to file 4", noremap = true},

}, { silent=true, prefix = '' })

local mappingListPlugin = require("maorun.telescope.mappingList")
mappingListPlugin.init()
wk.register({
    h = { function()
        if (vim.o.filetype == 'octo') then
            local mappings = require('octo.config').get_config().mappings
            local list = {}
            local k, v = next( mappings )
            while k do
                k, v = next( mappings, k )
                if (k ~= nil) then
                    for key, value in next, v do
                        -- print(vim.inspect(value))
                        table.insert(list, k .. " : " .. value.lhs .. " => " .. value.desc)

                    end
                end
            end
            mappingListPlugin.mappingList {
                title = "octo",
                list = list
            }
        end
    end, "help", noremap = true },
    q = {
        name = "General Commands",
        n = {
            name = "Create new X",
            b = { newBuffer, "new buffer", noremap = true },
            g = { ':GkeepNew<cr>', 'new google-note', noremap = true }
        },
        r =  {
            name = "Run X",
            t = {function()
                job({
                    command = 'npm',
                    args = { 'run', 'test', '--ignore-scripts'},
                }) 
            end, "run tests", noremap = true }
        },
    },
    a = {":lua require('harpoon.mark').add_file()<cr>", "Add file to mark", noremap = true},
    w = {":w<cr>zvzz", "Save", noremap = true},
    v = {
        name = "VimRC",
        e = {function()
            require('telescope.builtin').git_files {
                cwd = "~/dotfiles/",
                show_untracked = false,
                recurse_submodules = true,
                prompt_title = "* dotfiles *",
            }
        end, "find file in dotfiles", noremap = true},
        r = {":source $MYVIMRC<cr>:echo '~/.vimrc loaded'<cr>", "Load VimRC", noremap = true},
    },
    s = {
        name = "Session-Handling",
        s = { function ()
            local sessionFilename = vim.fn.expand("Session.vim")
            print(sessionFilename)
            if (vim.fn.filereadable(sessionFilename)) then
                -- from vim-obsession
                vim.cmd('source ' .. sessionFilename)
            else
                print("Session.vim not found")
            end
            -- ':call LoadSession()<cr>:echo "Session loaded"<cr>'
        end, "Load Session", noremap = true},
    },
    f = {
        name = "Formatting",
        j = {":%!jq .<cr>" , "JSON pretty print", noremap = true},
    },
    i = { "go to next indent", noremap = true},
    pi = { "go to previous indent", noremap = true},
    e = {":execute '!' .(expand(getline('.')))<cr>", "execute line under cursor (shellescape does not work)", noremap = true},
}, { silent=true, prefix = '<leader>' })

wk.register({
    n = {
        name = "NERDTree",
        f = {":NERDTreeFind<cr>", "current file", noremap = true },
        t = {":NERDTree<cr>", "open tree", noremap = true},
    },
    b = {
        name = "Buffer",
        n = { newBuffer, "new buffer", noremap = true },
    },
    c = {
        name = "COC",
        ["a"] = {"<Plug>(coc-codeaction)", "open coc", noremap = true},
        -- Apply AutoFix to problem on the current line.
        ["f"] = {"<Plug>(coc-fix-current)", "quickfix current problem", noremap = true },
        ["n"] = {"<plug>(coc-diagnostic-next)", "next problem", noremap = true },
        ["p"] = {"<Plug>(coc-diagnostic-prev)", "prev problem", noremap = true },
        ["r"] = {"<Plug>(coc-rename)", "rename", noremap = true },
        ["d"] = {"<Plug>(coc-definition)", "see definition", noremap = true },
        ["s"] = {"<Plug>(coc-references)", "see references", noremap = true },
        ["i"] = {"<Plug>(coc-implementation)", "goto implementations", noremap = true },
    },
}, { prefix = "<leader>" })

vim.cmd [[
    inoremap jk <Esc>
    vnoremap jk <Esc>
    cnoremap jk <Esc>


    " yank and paste to/from system-clipboard (Mac)
    vnoremap ç "+y
    nnoremap √ "+p
    inoremap √ <Esc>"+pa
]]

wk.register({
    ["<C-L>"] = { "<C-O>l", "move cursor right", noremap = true},
    ["<C-H>"] = { "<C-O>h", "move cursor left", noremap = true},
}, { mode = 'i'})

-- moving lines
wk.register({
    J = {":m '>+1<cr>gv=gv", "move line down", noremap = true},
    K = {":m '<-2<cr>gv=gv", "move line up", noremap = true},
}, { mode = 'v'})
wk.register({
    ["<C-J>"] = { "mk:m .+1<cr>==`k", "move line down", noremap = true},
    ["<C-K>"] = { "mk:m .-2<cr>==`k", "move line up", noremap = true},
}, { mode = 'n'})

wk.register({
    -- " float-menu up and down
    ["<C-J>"] = { "<Down>", "float-menu down", noremap = true},
    ["<C-K>"] = { "<Up>", "float-menu up", noremap = true},
--     ["<C-J>"] = { "<Esc>mk:m .+1<cr>==`ka", "move line down", noremap = true},
--     ["<C-K>"] = { "<Esc>mk:m .-2<cr>==`ka", "move line up", noremap = true},
}, { mode = 'i'})

wk.register({
    ['<C-SPACE>'] = {'coc#refresh()', noremap = true }
}, {mode = 'i' })
vim.cmd [[
    " inoremap <silent><expr> <c-space> coc#refresh()
]]
