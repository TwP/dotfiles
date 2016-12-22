--
-- Toggle "Do Not Disturb" in Notifications
--
-- NOTE: This is the text AppleScript, the LaunchBar action Info.plist refers to
-- a **COMPILED** .scpt version of this script. You can compile this text AppleScript
-- into .scpt using command line osacompile or by exporting/save-as within Script Editor
--

-- This handler is called when the user runs the action:
on run
  tell application "System Events"
    tell application process "SystemUIServer"
      try
        key down option

        -- MacOS prior to Sierra
        if exists menu bar 2 then
          click menu bar item 1 of menu bar 2

        -- MacOS Sierra
        else
          click menu bar item 1 of menu bar 1
        end if

        key up option

      on error e
        key up option
        display dialog e
        activate
      end try
    end tell
  end tell
end run
