--
-- Toggle "Do Not Disturb" in Notifications
--
-- NOTE: This is the text AppleScript, the LaunchBar action Info.plist refers to
-- a **COMPILED** .scpt version of this script. You can compile this text AppleScript
-- into .scpt using command line osacompile or by exporting/save-as within Script Editor
--

-- This handler is called when the user runs the action:
on run
  try
    tell application "System Events" to tell process "SystemUIServer"
      key down option
      click menu bar item 1 of menu bar 2
      key up option
    end tell
  on error e
    display dialog e
    activate
  end try
end run
