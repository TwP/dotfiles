--[[
Hammerspon initialization file
--]]

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

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

-- Enumerate the attached USB devices and see if one of them is the
-- Focusrite Scarlett interface. Returns `true` if the interface is attached and
-- returns `false` otherwise.
function isMicAttached()
  local rv = false
  local devices = hs.usb.attachedDevices()

  for _, device in pairs(devices) do
    if (device["vendorName"] == "Focusrite" and device["productName"] == "Scarlett 2i2 USB") then
      rv = true
      break
    end
  end

  return rv
end

-- Prints a debug message to the console to help identify the application and
-- event type received by the hs.application.watcher system.
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

-- An application watcher for Zoom that will start up Audio Hijack if the
-- external microphone is attached to the computer.
function zoomWatcher(appName, eventType, appObject)
  if (appName == "zoom.us" and isMicAttached()) then
    if     (eventType == hs.application.watcher.launching)  then startAudioHijack()
    elseif (eventType == hs.application.watcher.terminated) then stopAudioHijack()
    end
  end
end
appWatcher = hs.application.watcher.new(zoomWatcher)
appWatcher:start()

