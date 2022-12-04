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

function readHomeControlToken()
  local file = io.open(os.getenv("HOME") .. "/.dotfiles/secret/homecontrol", "r")
  local token = file:read("*line")
  io.close(file)
  return token
end
local homeControlToken = readHomeControlToken()

function triggerHomeKitScene(sceneName)
  local url = "homecontrol://x-callback-url/run-action?action-type=trigger-scene&item-type=scene&item-name=" .. sceneName ..
              "&home-name=My%20Home&authentication-token=" .. homeControlToken
  hs.execute("open -g \"" .. url .. "\"")
end

-- the `action` here should be one of "toggle", "activate", or "deactivate"
function triggerHomeKitDevice(room, device, action)
  local url = "homecontrol://x-callback-url/run-action?action-type=switch-device-status&item-type=device&item-name=" .. device ..
              "&room-name=" .. room ..
              "&home-name=My%20Home&activation-mode=" .. action ..
              "&authentication-token=" .. homeControlToken
  hs.execute("open -g \"" .. url .. "\"")
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function()
  -- hs.alert.show("Button 1")
  hs.application.open("zoom.us", 0, false)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "2", function()
  -- hs.alert.show("Button 2")
  triggerHomeKitScene("Forest")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "3", function()
  -- hs.alert.show("Button 3")
  triggerHomeKitScene("Daylight")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "4", function()
  -- hs.alert.show("Button 4")
  triggerHomeKitScene("Work%20Work%20Work")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "5", function()
  -- hs.alert.show("Button 1 (long press)")
  local zoom = hs.application.find("zoom.us")
  if (zoom == nil) then return end
  if (zoom:isRunning()) then zoom:kill() end
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "6", function()
  -- hs.alert.show("Button 2 (long press)")
  triggerHomeKitScene("Vintage%20Modern")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "7", function()
  hs.alert.show("Button 3 (long press)")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "8", function()
  -- hs.alert.show("Button 4 (long press)")
  triggerHomeKitDevice("Office", "Main%20Lights", "deactivate")
end)

