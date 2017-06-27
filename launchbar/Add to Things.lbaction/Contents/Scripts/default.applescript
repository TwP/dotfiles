-- Add to Things
-- LaunchBar Action
-- default.scpt
--
-- Copyright (c) 2014-2016 Objective Development
-- https://obdev.at/
--
-- Input Format
--   title #tag [project/area] ::note >duedate

on handle_string(s)
  tell application "Things3"
    parse quicksilver input s
  end tell
end handle_string
