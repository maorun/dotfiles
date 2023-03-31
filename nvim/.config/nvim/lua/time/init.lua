local Path = require "plenary.path"
local os_sep = require("plenary.path").path.sep
local uv = vim.loop

vim.g.maorun_time_paused = 0

local write_async = function(path, txt, flag)
    uv.fs_open(path, flag, 438, function(open_err, fd)
        assert(not open_err, open_err)
        uv.fs_write(fd, txt, -1, function(write_err)
            assert(not write_err, write_err)
            uv.fs_close(fd, function(close_err)
                assert(not close_err, close_err)
            end)
        end)
    end)
end

local append_async = function(path, txt)
    write_async(path, txt, "a")
end

local function save(obj)
    Path:new(obj.path):write(vim.fn.json_encode(obj.content), "w")
end

local obj = {
    path = vim.fn.stdpath "data" .. os_sep .. "maorun-time.json",
}

local defaultHoursPerWeekday = {
    Montag= 8,
    Dienstag = 7,
    Mittwoch = 6,
    Donnerstag = 8,
    Freitag = 8,
}

local function init()
    local p = Path:new(obj.path)
    if not p:exists() then
        p:touch { parents = true }
    end

    local data = Path:new(obj.path):read()
    if data ~= "" then
        obj.content = vim.json.decode(data)
    else
        obj.content = {}
    end
    obj.content['hoursPerWeekday'] = defaultHoursPerWeekday
    local sumHoursPerWeek = 0
    for key, value in pairs(obj.content.hoursPerWeekday) do
        sumHoursPerWeek = sumHoursPerWeek + value
    end
    if obj.content['data'] == nil then
        obj.content['data'] = {}
    end
    if obj.content['data'][os.date("%Y")] == nil then
        obj.content['data'][os.date("%Y")] = {}
    end

    local years = obj.content['data'][os.date("%Y")] 
    if years[os.date("%W")] == nil then
        years[os.date("%W")] = {
            summary = {
                overhour = 0,
            },
            weekdays = {}
        }
    end
    return obj
end

local function calculate(week)
    local weekdays = week['weekdays']
    local summary = week['summary']
    local years = obj.content['data'][os.date("%Y")] 
    local loggedWeekdays = 0
    local timeInWeek = 0
    summary.overhour = 0
    for weekdayName, items in pairs(weekdays) do
        local timeInWeekday = 0
        for key, value in pairs(items.items) do
            if value.diffInHours ~= nil then
                timeInWeek = timeInWeek + value.diffInHours
                timeInWeekday = timeInWeekday + value.diffInHours
            end
        end

        weekdays[weekdayName].summary = {
            overhour = timeInWeekday - obj.content['hoursPerWeekday'][weekdayName],
            diffInHours = timeInWeekday,
        }
        timeInWeekday = 0
        loggedWeekdays = loggedWeekdays + 1
        summary.overhour = summary.overhour + weekdays[weekdayName].summary.overhour
    end
end

function TimeStart(weekday, time)
    if (vim.g.maorun_time_paused == 1) then
        return
    end
    init()

    if weekday == nil then
        weekday = os.date("%A")
    end
    if time == nil then
        time = os.time()
    end
    local years = obj.content['data'][os.date("%Y")] 
    if years[os.date("%W")]['weekdays'][weekday] == nil then
        years[os.date("%W")]['weekdays'][weekday] = {
            summary = {},
            items = {}
        }
    end
    local dayItem = years[os.date("%W")]['weekdays'][weekday]
    local canStart = true
    for key,item in pairs(dayItem.items) do
        canStart = canStart and (item.startTime ~= nil and item.endTime ~= nil)
    end
    if canStart then
        table.insert(dayItem.items, {
            startTime = time,
            startReadable = os.date("%H:%M"),
        })
    end
    save(obj)
end

function TimeStop(weekday, time)
    if (vim.g.maorun_time_paused == 1) then
        return
    end
    init()

    if weekday == nil then
        weekday = os.date("%A")
    end
    if time == nil then
        time = os.time()
    end
    local years = obj.content['data'][os.date("%Y")] 
    local dayItem = years[os.date("%W")]['weekdays'][weekday]
    local canStart = true
    for key,item in pairs(dayItem.items) do
        if item.endTime == nil then
            item.endTime = time
            local timeReadable = os.date("*t", time)
            item.endReadable = string.format("%02d:%02d", timeReadable.hour, timeReadable.min)
            item.diffInHours = os.difftime(item.endTime, item.startTime) / 60 / 60
        end
    end
    calculate(years[os.date("%W")])
    save(obj)
end

-- calculate an average over the defaultHoursPerWeekday
local function calculateAverage()
    local sum = 0
    local count = 0
    for key, value in pairs(defaultHoursPerWeekday) do
        sum = sum + value
        count = count + 1
    end
    return sum / count
end

-- adds time into the current week
local function addTime(time, weekday)
    local years = obj.content['data'][os.date("%Y")] 
    if weekday == nil then
        weekday = os.date("%A")
    end
    local weekdayNumberMap = {
        ["Montag"] = 1,
        ["Dienstag"] = 2,
        ["Mittwoch"] = 3,
        ["Donnerstag"] = 4,
        ["Freitag"] = 5,
        ["Samstag"] = 6,
        ["Sonntag"] = 7,
    }
    local week = years[os.date("%W")]
    local diffDays =  weekdayNumberMap[os.date("%A")] - weekdayNumberMap[weekday]
    if diffDays < 0 then
        diffDays = diffDays + 7
    end
    
    print(weekday, diffDays, os.date("%d") - diffDays)
    if  week['weekdays'][weekday] == nil  then
        week['weekdays'][weekday] = {
            items = {}
        }
    end
    local items = week['weekdays'][weekday].items
    -- calculate(week)
    -- save(obj)
    print(os.date("%Y-%m-%d %H:%M:%S", os.time({
        year = os.date("%Y"),
        month = os.date("%m"),
        day = 1,
    })))
end

local timeGroup = vim.api.nvim_create_augroup('Maorun-Time', {})
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "VimEnter"}, {
    group = timeGroup,
    desc = 'Start Timetracking on VimEnter or BufEnter (if second vim was leaved)',
    callback = function() TimeStart() end,
})
vim.api.nvim_create_autocmd("VimLeave", {
    group = timeGroup,
    desc = 'End Timetracking on VimLeave',
    callback = function() TimeStop() end,
})
-- Überstunden letzte Woche: 3h

-- Montag: 9h von 8h (+1h => 4h)
-- Dienstag: 8h von 8h (0h => 4h)
-- Mittwoch: 3h von 8h (-5h => -1h)
-- Donnerstag: 9h von 8h (+1h => 0h)
-- Freitag: 8h von 8h (0h => 0h)

