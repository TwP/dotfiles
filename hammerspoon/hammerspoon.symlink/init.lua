--[[
Hammerspon initialization file
--]]

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
  -- hs.notify.show("Hammerspoon", "sub", "Hello World!")
end)

function startAudioHijack()
  local hijack = hs.application.open("com.rogueamoeba.audiohijack", 10, true)
  if (hijack == nil) then return end

  local start = hijack:findMenuItem({"Control", "Start Session"})
  local stop  = hijack:findMenuItem({"Control", "Stop Session"})

  if (start ~= nil) then hijack:selectMenuItem({"Control", "Start Session"}) end
end

function stopAudioHijack()
  local hijack = hs.application.find("com.rogueamoeba.audiohijack")
  if (hijack == nil) then return end

  local start = hijack:findMenuItem({"Control", "Start Session"})
  local stop  = hijack:findMenuItem({"Control", "Stop Session"})

  if (stop ~= nil) then hijack:selectMenuItem({"Control", "Stop Session"}) end
  if (hijack:isRunning()) then hijack:kill() end
end

hs.hotkey.bind({"cmd", "ctrl"}, "J", startAudioHijack)

function debugAppEvent(appName, eventType)
  local eventName = nil
  if     (eventType == hs.application.watcher.activated)   then eventName = "activated"
  elseif (eventType == hs.application.watcher.deactivated) then eventName = "deactivated"
  elseif (eventType == hs.application.watcher.hidden)      then eventName = "hidden"
  elseif (eventType == hs.application.watcher.launched)    then eventName = "launched"
  elseif (eventType == hs.application.watcher.launching)   then eventName = "launching"
  elseif (eventType == hs.application.watcher.terminated)  then eventName = "terminated"
  elseif (eventType == hs.application.watcher.unhidden)    then eventName = "unhidden"
  end
  print("[" .. appName .. "] - " .. eventName)
end

function applicationWatcher(appName, eventType, appObject)
  if (appName == "zoom.us") then
    if     (eventType == hs.application.watcher.launching)  then startAudioHijack()
    elseif (eventType == hs.application.watcher.terminated) then stopAudioHijack()
    end
  end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

