function CallAppleScript(application, command)
    local script = "osascript -e 'tell application \"" ..
        application .. "\"' -e '" .. command .. "' -e 'end tell' >> /dev/null &"
    vim.fn.system(script)
    vim.cmd ':redraw!'
end

Maorun = Maorun or {}
function Maorun.startUp()
    CallAppleScript('Microsoft Outlook', 'activate')
    CallAppleScript('Pieces', 'activate')
    CallAppleScript('Microsoft Teams', 'activate')
    -- CallAppleScript('Google Chrome', 'activate')
    CallAppleScript('Zen', 'activate')
    CallAppleScript('Cisco Secure Client', 'activate')
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
