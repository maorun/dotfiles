local notify = require('notify')

vim.cmd "nnoremap gx yiW:!open '<cWORD>'<CR><CR>"
vim.cmd "nnoremap gix yib:!open '<c-r>\"'<CR><CR>"
-- got to indention level
local function Indent_len(str)
    if type(str) == 'string' then
        return #str:match('^%s*') or 0
    else
        return 0
    end
end

local function Go_indent(times, dir)
    for _ = 1, times do
        local l = vim.fn.line('.')
        local x = vim.fn.line('$')
        local i = Indent_len(vim.fn.getline(l))
        local e = vim.fn.getline(l) == ''

        while l >= 1 and l <= x do
            local line = vim.fn.getline(l + dir)
            l = l + dir
            local indentOfLine = Indent_len(line)
            if (
                    indentOfLine > 0 and indentOfLine < i)
                or (dir > 0 and indentOfLine ~= i)
                or ((line == '') == false and (line == '') ~= e)
            then
                break
            end
        end

        l = math.min(math.max(1, l), x)
        vim.cmd('normal! ' .. l .. 'G^')
    end
end

-- local gs = require('gitsigns')
local gs = package.loaded.gitsigns
local wk = require('which-key')
wk.add({
    {
        '[i',
        function()
            Go_indent(vim.v.count1, -1)
        end,
        desc = 'go to indention level -1',
        silent = true
    },
    {
        ']i',
        function()
            Go_indent(vim.v.count1, 1)
        end,
        desc = 'go to indention level 1',
        silent = true
    },
    {
        '[h',
        function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end,
        desc = 'Prev Hunk',
        expr = true,
        replace_keycodes = false
    },
    {
        ']h',
        function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end,
        desc = 'Next Hunk',
        expr = true,
        replace_keycodes = false
    },
    {
        ']d',
        function()
            vim.diagnostic.jump({ count = 1, float = true })
            vim.cmd('normal! zz')
        end,
        desc = 'Jump to the next diagnostic in the current buffer'
    },
    {
        '[d',
        function()
            vim.diagnostic.jump({ count = -1, float = true })
            vim.cmd('normal! zz')
        end,
        desc = 'Jump to the previous diagnostic in the current buffer'
    },
    { '<',           '<gv',                                                 desc = 'indent left',                                           mode = 'x' },
    { '>',           '>gv',                                                 desc = 'indent right',                                          mode = 'x' },
    { '<C-E>',       '<C-B>',                                               desc = 'Scroll up' }, -- because of tmux
    { '<C-d>',       '<C-d>zz' },
    { '<C-h>',       '<C-g>u<Esc>[s1z=`]a<C-g>u',                           desc = 'fix prev spelling mistake',                             mode = 'i' },
    { '<C-i>',       '<C-i>zz' },
    { '<C-o>',       '<C-o>zz' },
    { '<C-u>',       '<C-u>zz' },
    { '<leader>b',   group = 'Buffer' },
    { '<leader>bb',  '<cmd>lua require("telescope.builtin").buffers()<cr>', desc = 'show Buffers', },
    { '<leader>bd',  ':%bd|e#<cr>',                                         desc = 'delete all buffers', },
    { '<leader>br',  ':edit!<cr>',                                          desc = 'reload buffer', },
    { '<leader>d',   group = 'Diff' },
    { '<leader>dd',  ':diffthis<cr>',                                       desc = 'Diff this', },
    { '<leader>df',  ':DiffviewFileHistory %<cr>',                          desc = 'Diffview File History' },
    { '<leader>df',  '<cmd>\'<,\'>DiffviewFileHistory<cr>',                 desc = 'Diffview File History',                                 mode = 'v' },
    { '<leader>dq',  ':diffoff!<cr>',                                       desc = 'Diff off', },
    { '<leader>dr',  group = 'Diffview' },
    { '<leader>dro', ':DiffviewOpen<cr>',                                   desc = 'Diffview Open' },
    { '<leader>drq', ':DiffviewClose<cr>',                                  desc = 'Diffview Close' },
    { '<leader>drs', ':Gitsigns diffthis<cr>',                              desc = 'Diffthis / with index', },
    { '<leader>e',   ":execute '!' .(expand(getline('.')))<cr>",            desc = 'execute line under cursor (shellescape does not work)', },
    { '<leader>f',   group = 'Formatting' },
    { '<leader>fj',  ':%!jq .<cr>',                                         desc = 'JSON pretty print', },
    { '<leader>ga',  group = 'Amend' },
    {
        '<leader>gaa',
        function()
            vim.cmd [[
        :G add -A
        :G commit --amend --no-edit
        ]]
        end,
        desc = 'Amend',
    },
    {
        '<leader>gap',
        function()
            vim.cmd [[
        :G add -A
        :G commit --amend --no-edit
        :execute ":G push --force origin " . FugitiveHead()
        ]]
        end,
        desc = 'Amend and Push',
    },
    { '<leader>gb',  group = 'Branches' },
    { '<leader>gba', "<cmd>lua require'telescope.builtin'.git_branches()<cr>",                         desc = 'Git all branches', },
    { '<leader>gbb', "<cmd>lua require'telescope.builtin'.git_branches({pattern = 'refs/heads'})<cr>", desc = 'Git lokal branches', },
    { '<leader>gbm', ':G branch -m ',                                                                  desc = 'Git branch move', },
    {
        '<leader>gbn',
        function()
            vim.ui.input({ prompt = 'New branch name: ' }, function(branch)
                if branch == nil then
                    return
                end
                vim.cmd(':silent G fetch --prune')
                -- create branch
                vim.cmd(string.format(':silent G branch %s origin/master', branch))
                vim.cmd(string.format(':silent G checkout %s', branch))
                notify('new branch created')
            end)
        end,
        desc = 'Git New Branch',
    },
    { '<leader>gbr', "<cmd>lua require'telescope.builtin'.git_branches({pattern = 'refs/remotes'})<cr>", desc = 'Git remote branches', },
    { '<leader>gf',  ':G fetch --prune<cr>',                                                             desc = 'Git Fetch', },
    { '<leader>gg',  "<cmd>lua require'telescope.builtin'.git_files{}<cr>",                              desc = 'Git files', },
    {
        '<leader>gl',
        function()
            vim.cmd [[
        :Flogsplit -all -date=short
        :execute "/HEAD -> " . FugitiveHead()
        :nohlsearch
        ]]
        end,
        desc = 'Git Log',
    },
    { '<leader>gp',  group = 'Push & Pull' },
    {
        '<leader>gpf',
        function()
            vim.cmd [[
        :execute ":G push --force origin " . FugitiveHead()
        ]]
        end,
        desc = 'Force Push',
    },
    {
        '<leader>gpp',
        function()
            vim.cmd [[
        :execute ":G push origin " . FugitiveHead()
        :execute ":G branch --set-upstream-to=origin/" . FugitiveHead() . " " . FugitiveHead()
        ]]
            notify('git-push finished')
        end,
        desc = 'Push',
    },
    {
        '<leader>gpu',
        ':G pull | :lua  require("notify")("git-pull finished")<cr>',
        desc = 'Pull',
    },
    { '<leader>gr',  group = 'Git Rebase' },
    { '<leader>grA', ':G merge --abort<cr>',                           desc = 'Git Merge abort', },
    { '<leader>gra', ':G rebase --abort<cr>',                          desc = 'Git Rebase abort', },
    { '<leader>grC', ':G merge --continue<cr>',                        desc = 'Git Merge continue', },
    { '<leader>grc', ':G rebase --continue<cr>',                       desc = 'Git Rebase continue', },
    { '<leader>grM', ':G fetch --prune | :G merge origin/master<cr>',  desc = 'Git Merge master', },
    { '<leader>grm', ':G fetch --prune | :G rebase origin/master<cr>', desc = 'Git Rebase master', },
    { '<leader>grn', ':G rebase ',                                     desc = 'Git Rebase', },

    {
        '<leader>gro',
        function()
            vim.cmd(':execute ":G reset --hard origin/" . FugitiveHead()')
        end,
        desc = 'Git Reset origin',
    },

    { '<leader>grr', ':G rebase -i HEAD~',            desc = 'Git Rebase interactive', },
    { '<leader>gs',  group = 'Git Stash' },
    { '<leader>gsa', ':G stash<cr>',                  desc = 'Git Stash add', },
    { '<leader>gsl', '<cmd>Telescope git_stash<cr>',  desc = 'Stash list', },
    { '<leader>gsp', ':G stash pop<cr>',              desc = 'Git Stash pop', },
    { '<leader>gss', '<cmd>Telescope git_status<cr>', desc = 'changed files', },
    {
        '<leader>gw',
        function()
            vim.cmd [[
    :G commit --no-verify -m 'wip'
        :execute ":G push origin " . FugitiveHead()
        :execute ":G branch --set-upstream-to=origin/" . FugitiveHead() . " " . FugitiveHead()
    ]]
        end,
        desc = 'WIP',
    },
    { '<leader>h',   group = 'git Hunk' },
    { '<leader>hA',  gs.stage_buffer,                                                                 desc = 'Stage Buffer', },
    { '<leader>ha',  gs.stage_hunk,                                                                   desc = 'Stage Hunk', },
    { '<leader>hb',  function() gs.blame_line { full = true } end,                                    desc = 'Blame Line', },
    { '<leader>hD',  function() gs.blame_line { full = true } end,                                    desc = 'Diff This (ignore whitespace)', },
    { '<leader>hd',  gs.diffthis,                                                                     desc = 'Diff This', },
    { '<leader>hp',  gs.preview_hunk,                                                                 desc = 'Preview Hunk', },
    { '<leader>hR',  gs.reset_buffer,                                                                 desc = 'Reset Buffer', },
    { '<leader>hr',  gs.reset_hunk,                                                                   desc = 'Reset Hunk', },
    { '<leader>hr',  function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,             desc = 'Reset Hunk',                       mode = 'v', },
    { '<leader>hS',  gs.stage_buffer,                                                                 desc = 'Stage Buffer', },
    { '<leader>hs',  gs.stage_hunk,                                                                   desc = 'Stage Hunk', },
    { '<leader>hs',  function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,             desc = 'Stage Hunk',                       mode = 'v', },
    { '<leader>hu',  gs.undo_stage_hunk,                                                              desc = 'Undo Stage Hunk', },
    { '<leader>i',   desc = 'go to next indent', },
    { '<leader>ih',  ':<C-U>Gitsigns select_hunk<CR>',                                                desc = 'Select Hunk',                      mode = { 'o', 'x' }, },
    { '<leader>n',   group = 'file-browse' },
    { '<leader>nf',  ':Telescope file_browser follow_symlink=true path=%:p:h select_buffer=true<cr>', desc = 'current file', },
    { '<leader>nt',  ':Telescope file_browser respect_gitignore=true<cr>',                            desc = 'open tree', },
    { '<leader>pi',  desc = 'go to previous indent', },
    { '<leader>q',   group = 'General Commands' },
    { '<leader>qo',  ':lua OpenCurrentFileInVisualCode()<CR>',                                        desc = 'open current file in visual code', },
    { '<leader>qs',  ":call CallAppleScript('Spotify', 'playpause')<cr>",                             desc = 'Spotify play/pause', },
    { '<leader>qu',  ':lua Maorun.startUp()<CR>',                                                     desc = 'StartUp', },
    { '<leader>r',   group = 'Refactor/Debug' },
    { '<leader>rd',  group = 'debugs' },
    { '<leader>rdc', ":lua require('refactoring').debug.cleanup({})<CR>",                             desc = 'delete debugs' },
    { '<leader>rdP', ":lua require('refactoring').debug.printf({below = false})<CR>",                 desc = 'add print-statement' },
    { '<leader>rdp', ":lua require('refactoring').debug.printf({below = true})<CR>",                  desc = 'add print-statement' },
    { '<leader>rdv', ":lua require('refactoring').debug.print_var({ normal = true })<CR>",            desc = 'print variable', },
    { '<leader>rr',  ":lua require('telescope').extensions.refactoring.refactors()<cr>",              desc = 'refactor-telescope',               mode = { 'x', 'n' }, },
    { '<leader>S',   require('substitute').eol, },
    { '<leader>s',   require('substitute').operator,                                                  group = 'Substitute' },
    { '<leader>s',   require('substitute').visual,                                                    mode = 'x' },
    { '<leader>ss',  require('substitute').line, },
    { '<leader>t',   group = 'Telescope/Time/Other/Octo' },
    { '<leader>tf',  "<cmd>lua require('telescope.builtin').find_files()<cr>",                        desc = 'Find files', },
    { '<leader>tl',  "<cmd>lua require('telescope.builtin').oldfiles({cwd_only=true})<cr>",           desc = 'Find last opened files', },
    { '<leader>tn',  group = ':Other' },
    { '<leader>tnn', '<cmd>:Other<cr>',                                                               desc = ':Other', },
    { '<leader>tns', '<cmd>:OtherSplit<cr>',                                                          desc = ':OtherSplit', },
    { '<leader>tnv', '<cmd>:OtherVSplit<cr>',                                                         desc = ':OtherVSplit', },
    { '<leader>to',  group = 'Octo' },
    { '<leader>toa', ':Octo actions<cr>',                                                             desc = 'Octo actions', },
    { '<leader>toc', ':Octo pr create draft<cr>',                                                     desc = 'create PR draft', },
    {
        '<leader>tok',
        function()
            local mappingListPlugin = require('maorun.mappingList')
            mappingListPlugin.init()
            mappingListPlugin.mappingList {
                title = 'Repositories',
                list = { 'maorun/code-stats', 'maorun/snyk.nvim', 'spring-media/ac-steam', 'spring-media/maps-setup-hh-flux-cd', 'spring-media/ac-steam-flux', },
                action = function(value)
                    vim.cmd('Octo pr list ' .. value)
                end
            }
        end,
        desc = 'list pr of a list of repos',
    },
    {
        '<leader>tol',
        function()
            local plenaryJob = require 'plenary.job'
            local lines = {}
            plenaryJob:new({
                silent = false,
                command = 'gh',
                args = {
                    'pr', 'list', '--state', 'open', '--json',
                    'author,number,title,reviewDecision',
                },
                interactive = false,
                on_stdout = function(_, data)
                    table.insert(lines, data)
                end,
                on_stderr = function(_, data)
                    table.insert(lines, data)
                end,
                on_exit = function()
                    vim.schedule(function()
                        local item = (vim.json.decode(lines[1]))
                        if #item == 0 then
                            notify('no PRs to review in ' .. vim.loop.cwd())
                            return
                        end

                        local prs = {}
                        for _, value in pairs(item) do
                            if (
                                    value.reviewDecision ~= 'APPROVED'
                                    and value.author.login ~= 'app/renovate'
                                ) then
                                table.insert(prs,
                                    value.number .. ' | ' ..
                                    value.author.login .. ' | ' ..
                                    value.title .. ' | ' ..
                                    value.reviewDecision
                                )
                            end
                        end
                        local mappingListPlugin = require('maorun.mappingList')
                        mappingListPlugin.init()
                        mappingListPlugin.mappingList {
                            title = 'PR list',
                            list = prs,
                            action = function(value)
                                local pr = vim.split(value, '|')[1]
                                vim.cmd('Octo pr edit ' .. pr)
                            end
                        }
                    end)
                end,
            }):start()
        end,
        desc = 'list PR',
    },
    {
        '<leader>too',
        function()
            local plenaryJob = require 'plenary.job'
            local lines = {}
            plenaryJob:new({
                silent = false,
                command = 'gh',
                args = {
                    'pr', 'list', '--state', 'open', '--json',
                    'author,number,title,reviewDecision',
                },
                interactive = false,
                on_stdout = function(_, data)
                    table.insert(lines, data)
                end,
                on_stderr = function(_, data)
                    table.insert(lines, data)
                end,
                on_exit = function()
                    vim.schedule(function()
                        local item = (vim.json.decode(lines[1]))
                        if #item == 0 then
                            notify('no PRs to review in ' .. vim.loop.cwd())
                            return
                        end

                        local prs = {}
                        for _, value in pairs(item) do
                            if (
                                    value.reviewDecision == 'APPROVED'
                                    and value.author.login == 'maorun'
                                ) then
                                table.insert(prs,
                                    value.number .. ' | ' ..
                                    value.author.login .. ' | ' ..
                                    value.title .. ' | ' ..
                                    value.reviewDecision
                                )
                            end
                        end
                        local mappingListPlugin = require('maorun.mappingList')
                        mappingListPlugin.init()
                        mappingListPlugin.mappingList {
                            title = 'PR list',
                            list = prs,
                            action = function(value)
                                local pr = vim.split(value, '|')[1]
                                vim.cmd('Octo pr edit ' .. pr)
                            end
                        }
                    end)
                end,
            }):start()
        end,
        desc = 'list approved PRs from me',
    },
    { '<leader>top', function() require 'telescope'.extensions.project.project { display_type = 'full' } end, desc = 'should be keybind of tp fur Project', },
    { '<leader>tp',  function() require 'telescope'.extensions.project.project { display_type = 'full' } end, desc = 'Project', },

    {
        '<leader>tr',
        function()
            require('telescope.builtin').live_grep {
                vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '-g', '!git/**' }
            }
        end,
        desc = 'Live Grep',
    },

    { '<leader>tt',  group = 'Time' },
    { '<leader>ttp', '<cmd>lua Time.TimePause()<cr>',  desc = 'TimePause', },
    { '<leader>ttr', '<cmd>lua Time.TimeResume()<cr>', desc = 'TimeResume', },
    { '<leader>tts', '<cmd>lua Time.TimeStop()<cr>',   desc = 'TimeStop', },
    {
        '<leader>ve',
        function()
            require('telescope').extensions.file_browser.file_browser({
                path =
                '~/dotfiles/',
                prompt_title = '* dotfiles *',
            })
        end,
        desc = 'find file in dotfiles',
    },
    { '<leader>vtf', '<cmd>TestFile<cr>',                       desc = 'runs the whole test file', },
    { '<leader>vtn', '<cmd>TestNearest<cr>',                    desc = 'runs the test nearest to the cursor', },
    { '<leader>vts', '<cmd>TestSuite<cr>',                      desc = 'runs the whole test suite', },
    { '<leader>w',   ':w<cr>zvzz',                              desc = 'Save', },
    { 'ihe',         ':exec "normal! ggVG"<cr>',                desc = 'select all',                          mode = 'o', },
    { 'jk',          '<Esc>',                                   desc = 'to normal mode',                      mode = { 'i', 'v', 'c' } },
    { 'n',           'nzz',                                     desc = 'next search' },
    { 'N',           'Nzz',                                     desc = 'prev search' },
    { mode = 'i',    { '<C-n>', '<Plug>luasnip-next-choice', }, { '<C-p>', '<Plug>luasnip-prev-choice', } },
})

-- add j to jumplist
vim.keymap.set('n', 'j', function()
    if vim.v.count > 0 then
        return "m'" .. vim.v.count .. 'jzz'
    end
    return 'j'
end, { expr = true })

-- add k to jumplist
vim.keymap.set('n', 'k', function()
    if vim.v.count > 0 then
        return "m'" .. vim.v.count .. 'kzz'
    end
    return 'k'
end, { expr = true })

-- vim.cmd[[inoremap <c-u> <cmd>lua require("luasnip.extras.select_choice")()<cr>]]
vim.keymap.set('', 'S', function() require('hop').hint_char2({ multi_windows = true }) end,
    { remap = true })
vim.keymap.set('', 's', function() require('hop').hint_char2({ multi_windows = true }) end,
    { remap = true })
local augroup = vim.api.nvim_create_augroup('ai_model', {})
vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'mchat',
    command = 'nnoremap <silent><buffer> <leader>w :Mchat<cr>',
})
vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'gitcommit',
    callback = function()
        vim.opt.spell = true
        wk.add({
            { '<leader>gc', ':M commit<cr>', desc = 'generate message', remap = true },
        })
    end
})
local octoGroup = vim.api.nvim_create_augroup('Octo', {})
vim.api.nvim_create_autocmd('FileType', {
    group = octoGroup,
    pattern = 'octo',
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'i', '@', '@<C-x><C-o>', { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'i', '#', '#<C-x><C-o>', { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ppc', ':Octo pr checks<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pps',
            ':%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2<cr>:nohlsearch<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rs', ':Octo review start<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rn', ':Octo review resume<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rd', ':Octo pr ready<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pr', ':Octo thread resolve<cr>',
            { silent = true, })
        wk.add({
            {
                '<leader>k',
                function()
                    local w = vim.fn.expand('<cword>')
                    if tonumber(w) then
                        vim.notify('open pr #' .. w)

                        vim.schedule(function()
                            vim.cmd('Octo pr edit ' .. w)
                        end)

                        return ''
                    else
                        return 'K'
                    end
                end,
                expr = true,
            },
            {
                '<leader>ppm',
                function()
                    vim.ui.select({ 'yes', 'no' }, {
                        prompt = 'Merge Squash?',
                        kind = 'ass'
                    }, function(selected)
                        if (selected == 'yes') then
                            local commands = require('octo.commands')
                            commands.merge_pr('squash')
                            -- print('branch squasched')
                            -- vim.api.nvim_command('edit!') -- reload current buffer
                        end
                    end
                    )
                end
                ,
                desc = 'squash-merge'
            },
            {
                '<leader>rq',
                ':split | terminal grd ' .. vim.fn.expand('%:t') .. '<cr>a',
                desc = 'dismissReview'
            }
        })
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-N>', ':Octo pr browser<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>sf',
            ':%s/.*\\[\\(\\d\\+\\).*](\\(.*\\))/\\1 \\2/<cr><C-l>', { silent = true, })
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    group = octoGroup,
    pattern = 'octo_panel',
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rs', ':Octo review submit<cr>',
            { silent = true, })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rq', ':Octo review discard<cr>',
            { silent = true, })
    end,
})

vim.cmd [[
    nnoremap <silent> <leader>u :set operatorfunc=DeepL<cr>g@
    vnoremap <leader>u :<c-u>call DeepL(visualmode())<cr>

    " yank and paste to/from system-clipboard (Mac)
    vnoremap <silent> ç "+y
    vnoremap <silent> <M-c> "+y
    nnoremap <silent> ç :set operatorfunc=CopyToSystemClipboard<cr>g@
    nnoremap <silent> <M-c> :set operatorfunc=CopyToSystemClipboard<cr>g@
    nnoremap <silent> √ "+p
    nnoremap <silent> <M-v> "+p
    inoremap <silent> √ <Esc>"+pa
    inoremap <silent> <M-v> <Esc>"+pa

    function! CopyToSystemClipboard(type)
        if a:type ==# 'line'
            silent execute "normal! `[V`]\"+y"
        elseif a:type ==# 'char'
            silent execute "normal! `[v`]\"+y"
        else
            return
        endif

        " echo @@ "yanked into clipboard"
    endfunction
]]
