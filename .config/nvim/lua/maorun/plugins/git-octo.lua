---@param query string
---@param ... string|table
---@return string
local function graphql(query, ...)
    local queries = require 'octo.gh.queries'
    local mutations = require 'octo.gh.mutations'
    local pull_requests = [[
    query($endCursor: String) {
  repository(owner: "%s", name: "%s") {
    pullRequests(first: 100, after: $endCursor, %s, orderBy: {field: %s, direction: %s}) {
      nodes {
        __typename
        author {
          login
        }
        number
        reviewDecision
        title
        url
        repository { nameWithOwner }
        headRefName
        isDraft
        state
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
        ]]
    queries['pull_requests'] = pull_requests

    local suffix, module
    if vim.endswith(query, '_mutation') then
        module = mutations
        suffix = '_mutation'
    else
        module = queries
        suffix = '_query'
    end

    query = query:gsub(suffix, '')

    local opts = { escape = true }
    for _, v in ipairs { ... } do
        if type(v) == 'table' then
            opts = vim.tbl_deep_extend('force', opts, v)
            break
        end
    end
    local args = {}
    for _, v in ipairs { ... } do
        table.insert(args, v)
    end
    return string.format(module[query], unpack(args))
end

local function get_filter(opts, kind)
    local filter = ''
    local allowed_values = {}
    if kind == 'issue' then
        allowed_values = { 'since', 'createdBy', 'assignee', 'mentioned', 'labels', 'milestone',
            'states' }
    elseif kind == 'pull_request' then
        allowed_values = { 'baseRefName', 'headRefName', 'labels', 'states' }
    end

    for _, value in pairs(allowed_values) do
        if opts[value] then
            local val = {}
            if #vim.split(opts[value], ',') > 1 then
                -- list
                val = vim.split(opts[value], ',')
            else
                -- string
                val = opts[value]
            end
            val = vim.json.encode(val)
            val = string.gsub(val, '"OPEN"', 'OPEN')
            val = string.gsub(val, '"CLOSED"', 'CLOSED')
            val = string.gsub(val, '"MERGED"', 'MERGED')
            filter = filter .. value .. ':' .. val .. ','
        end
    end

    return filter
end

--- Create a replace function for the picker
--- @param cb function Callback function to call with the selected entry
--- @return function Replace function that takes a prompt_bufnr and calls the callback with the selected entry
local function create_replace(cb)
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    return function(prompt_bufnr, _)
        local selected = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        cb(selected)
    end
end

local function open(command)
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local utils = require 'octo.utils'
    return function(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        if command == 'default' then
            vim.cmd [[:buffer %]]
        elseif command == 'horizontal' then
            vim.cmd [[:sbuffer %]]
        elseif command == 'vertical' then
            vim.cmd [[:vert sbuffer %]]
        elseif command == 'tab' then
            vim.cmd [[:tab sb %]]
        end
        if selection then
            utils.get(selection.kind, selection.value, selection.repo)
        end
    end
end

local function open_buffer(prompt_bufnr, type)
    open(type)(prompt_bufnr)
end

local function checkout_pull_request()
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local utils = require 'octo.utils'
    return function(prompt_bufnr)
        local sel = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        utils.checkout_pr(sel.obj.number)
    end
end

local function open_in_browser()
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local navigation = require 'octo.navigation'
    return function(prompt_bufnr)
        local entry = action_state.get_selected_entry(prompt_bufnr)
        local number
        local repo = entry.repo
        if entry.kind ~= 'repo' then
            number = entry.value
        end
        actions.close(prompt_bufnr)
        navigation.open_in_browser(entry.kind, repo, number)
    end
end

local function copy_url()
    local action_state = require 'telescope.actions.state'
    local utils = require 'octo.utils'
    return function(prompt_bufnr)
        local entry = action_state.get_selected_entry(prompt_bufnr)
        utils.copy_url(entry.obj.url)
    end
end

local function merge_pull_request()
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local utils = require 'octo.utils'
    return function(prompt_bufnr)
        local sel = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        utils.merge_pr(sel.obj.number)
    end
end

function Pull_requests(opts)
    local action_set = require 'telescope.actions.set'
    local conf = require('telescope.config').values
    local finders = require 'telescope.finders'
    local pickers = require 'telescope.pickers'
    local gh = require 'octo.gh'
    local previewers = require 'octo.pickers.telescope.previewers'
    local entry_maker = require 'octo.pickers.telescope.entry_maker'
    local utils = require 'octo.utils'
    local octo_config = require 'octo.config'

    opts = opts or {}
    if not opts.states then
        opts.states = 'OPEN'
    end
    local filter = get_filter(opts, 'pull_request')
    if utils.is_blank(opts.repo) then
        opts.repo = utils.get_remote_name()
    end
    if not opts.repo then
        utils.error 'Cannot find repo'
        return
    end

    local replace = opts.cb and create_replace(opts.cb) or open_buffer

    local owner, name = utils.split_repo(opts.repo)
    local cfg = octo_config.values
    local order_by = cfg.pull_requests.order_by
    local query =
        graphql('pull_requests_query', owner, name, filter, order_by.field, order_by.direction,
            { escape = false })
    -- utils.info 'Fetching pull requests (this may take a while) ...'
    gh.run {
        args = { 'api', 'graphql', '--paginate', '--jq', '.', '-f', string.format('query=%s', query) },
        cb = function(output, stderr)
            if stderr and not utils.is_blank(stderr) then
                utils.error(stderr)
            elseif output then
                local resp = utils.aggregate_pages(output, 'data.repository.pullRequests.nodes')
                local pull_requests = resp.data.repository.pullRequests.nodes
                if #pull_requests == 0 then
                    utils.error(string.format('There are no matching pull requests in %s.', opts
                        .repo))
                    return
                end
                for i = #pull_requests, 1, -1 do
                    if pull_requests[i].reviewDecision == 'APPROVED' then
                        table.remove(pull_requests, i)
                    end
                    if pull_requests[i] ~= nil and pull_requests[i].author.login == 'renovate' then
                        table.remove(pull_requests, i)
                    end
                end
                local max_number = -1
                for _, pull in ipairs(pull_requests) do
                    if #tostring(pull.number) > max_number then
                        max_number = #tostring(pull.number)
                    end
                end
                opts.preview_title = opts.preview_title or ''
                opts.prompt_title = opts.prompt_title or ''
                opts.results_title = opts.results_title or ''
                pickers
                    .new(opts, {
                        finder = finders.new_table {
                            results = pull_requests,
                            entry_maker = entry_maker.gen_from_issue(max_number),
                        },
                        sorter = conf.generic_sorter(opts),
                        previewer = previewers.issue.new(opts),
                        attach_mappings = function(_, map)
                            action_set.select:replace(replace)
                            map('i', cfg.picker_config.mappings.checkout_pr.lhs,
                                checkout_pull_request())
                            map('i', cfg.picker_config.mappings.open_in_browser.lhs,
                                open_in_browser())
                            map('i', cfg.picker_config.mappings.copy_url.lhs, copy_url())
                            map('i', cfg.picker_config.mappings.merge_pr.lhs, merge_pull_request())
                            return true
                        end,
                    })
                    :find()
            end
        end,
    }
end

return {
    'pwntester/octo.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        mappings = {
            file_panel = {
                toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
            }
        }
    },
}
