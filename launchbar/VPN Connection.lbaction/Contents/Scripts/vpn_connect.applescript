--
-- Manage Viscocity VPN connections
--
-- NOTE: This is the text AppleScript, the LaunchBar action Info.plist refers to
-- a **COMPILED** .scpt version of this script. You can compile this text AppleScript
-- into .scpt using command line osacompile or by exporting/save-as within Script Editor
--

-- This handler is called when the user runs the action:
on run
  try
    tell application "Viscosity"
      set theResult to []
      repeat with theConnection in connections
        set connectionName to name of theConnection
        if the state of theConnection is "Connected" then
          set theResult to theResult & [{title: connectionName, badge: "Disconnect", action: "disconnect", actionArgument: connectionName, actionRunsInBackground: true, icon: "character:🔓"}]
        else
          set theResult to theResult & [{title: connectionName, badge: "Connect", action: "connect", actionArgument: connectionName, actionRunsInBackground: true, icon: "character:🔒"}]
        end if
      end repeat
    end tell
  on error e
    display dialog e
    activate
  end try
  return theResult
end run

-- This handler is called when the user selects "Connect" for a connection
on connect(connectionName)
  try
    tell application "Viscosity" to connect connectionName
  on error e
    display dialog e
    activate
  end try
end

-- This handler is called when the user selects "Disconnect" for a connection
on disconnect(connectionName)
  try
    tell application "Viscosity" to disconnect connectionName
  on error e
    display dialog e
    activate
  end try
end
