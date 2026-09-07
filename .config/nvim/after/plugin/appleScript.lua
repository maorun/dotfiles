function CallAppleScript(application, command)
  local script = "osascript -e 'tell application \"" ..
      application .. "\"' -e '" .. command .. "' -e 'end tell' >> /dev/null &"
  vim.fn.system(script)
  vim.cmd ':redraw!'
end

function OpenOutlook()
  local script = [[
    tell application "Microsoft Outlook"
      activate
    end tell

    delay 1

  tell application "System Events"
      keystroke "2" using {command down}
  end tell

  tell application "System Events"
      keystroke "1" using {command down}
  end tell
  ]]

  vim.fn.system({ "osascript", "-e", script })
end

Maorun = Maorun or {}
function Maorun.startUp()
  -- CallAppleScript('Cursor', 'activate')
  OpenOutlook()
  -- CallAppleScript('Microsoft Outlook', 'activate')
  -- kalender einträge
  CallAppleScript('Pieces', 'activate')
  CallAppleScript('Microsoft Teams', 'activate')
  -- CallAppleScript('Google Chrome', 'activate')
  CallAppleScript('Zen', 'activate')
  CallAppleScript('Cisco Secure Client', 'activate')
  CallAppleScript('Neo4j Desktop 2', 'activate')
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
