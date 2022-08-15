--[[
Hammerspon initialization file
--]]

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
  -- hs.notify.show("Hammerspoon", "sub", "Hello World!")
end)

function start_audio_hijack()
  local hijack = hs.application.open("com.rogueamoeba.audiohijack", 10, true)
  if (hijack == nil) then return end

  local start = hijack:findMenuItem({"Control", "Start Session"})
  local stop  = hijack:findMenuItem({"Control", "Stop Session"})

  if (start ~= nil) then
    hijack:selectMenuItem({"Control", "Start Session"})
  end
end
hs.hotkey.bind({"cmd", "ctrl"}, "J", start_audio_hijack)


function applicationWatcher(appName, eventType, appObject)
  if (appName == "zoom.us" and eventType == hs.application.watcher.launching) then
    start_audio_hijack()
  end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

