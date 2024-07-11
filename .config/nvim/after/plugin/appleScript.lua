local wk = require "which-key"
wk.register({
    q = {
        name = "General Commands",
        u = {":lua Maorun.startUp()<CR>", "StartUp", noremap = true},
        s = {":call CallAppleScript('Spotify', 'playpause')<cr>", "Spotify play/pause", noremap = true},
    },
}, { prefix = "<leader>" })

local function CallAppleScript(application, command)
    local script = "osascript -e 'tell application \"" .. application .. "\"' -e '" .. command .. "' -e 'end tell' >> /dev/null &"
    vim.fn.system(script)
    vim.cmd ":redraw!"
end

vim.cmd [[
    function! CallAppleScript(application, command)
        :silent execute "!osascript -e 'tell application \"" . a:application ."\"' -e '" . a:command . "' -e 'end tell' >> /dev/null &"
        :redraw!
    endfunction
    command! TunnelblickStop :call CallAppleScript("/Applications/Tunnelblick.app", 'disconnect "openvpn"')
]]
Maorun = Maorun or {}
function Maorun.startUp()
    CallAppleScript("Microsoft Outlook", "activate")
    CallAppleScript("Microsoft Teams", "activate")
    -- vim.fn.system('open /Applications/Microsoft\\ Teams\\ classic.app')
    -- vim.fn.system('open /Applications/Microsoft\\ Teams\\ \\(work\\ or\\ school\\).app')
    CallAppleScript("Google Chrome", "activate")
    -- CallAppleScript("Tunnelblick", 'connect "openvpn"')
    -- CallAppleScript("Tunnelblick", 'disconnect "openvpn"')
    -- vim.ui.select({ 'yes', 'no' }, {
    --     prompt = 'Spotify?',
    --     kind = 'ass'
    -- }, function(selected)
    --         if (selected == 'yes') then
    --             CallAppleScript("Spotify", "play")
    --         end
    --     end
    -- )
end
