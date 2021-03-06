--
-- Pause and resume Dropbox syncing
--
-- NOTE: This is the text AppleScript, the LaunchBar action Info.plist refers to
-- a **COMPILED** .scpt version of this script. You can compile this text AppleScript
-- into .scpt using command line osacompile or by exporting/save-as within Script Editor
--

-- This handler is called when the user runs the action:
on run()
  set theResult to []
  set theResult to theResult & [{title: "Pause syncing",  action: "pause",  actionRunsInBackground: true, icon: "font-awesome:fa-pause"}]
  set theResult to theResult & [{title: "Resume syncing", action: "resume", actionRunsInBackground: true, icon: "font-awesome:fa-play" }]
  return theResult
end run

-- This handler is called when the user selects "Pause syncing"
on pause()
  tell application "System Events"
    tell application process "Dropbox"
      try
        click menu bar item 1 of menu bar 2

        set currentState to name of UI element 5 of UI element 1 of window 1
        if (currentState ends with "paused") then
          click menu bar item 1 of menu bar 2
        else
          click menu button 1 of UI element 1 of window 1
          click menu item "Pause Syncing" of menu 1 of menu button 1 of UI element 1 of window 1
        end if
      on error e
        click menu bar item 1 of menu bar 2
        display dialog e
        activate
      end try
    end tell
  end tell
end pause

-- This handler is called when the user selects "Resume syncing"
on resume()
  tell application "System Events"
    tell application process "Dropbox"
      try
        click menu bar item 1 of menu bar 2

        set currentState to name of UI element 5 of UI element 1 of window 1
        if (currentState ends with "paused") then
          click menu button 1 of UI element 1 of window 1
          click menu item "Resume Syncing" of menu 1 of menu button 1 of UI element 1 of window 1
        else
          click menu bar item 1 of menu bar 2
        end if
      on error e
        click menu bar item 1 of menu bar 2
        display dialog e
        activate
      end try
    end tell
  end tell
end resume
