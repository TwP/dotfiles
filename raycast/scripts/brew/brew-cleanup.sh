#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Cleanup
# @raycast.mode fullOutput
# @raycast.packageName Brew
#
# Optional parameters:
# @raycast.icon 🍺
#
# Documentation:
# @raycast.description Run Brew Cleanup
# @raycast.author Tim Pease
# @raycast.authorURL https://pea53.com

if ! command -v brew &> /dev/null; then
  echo "brew command is required (https://brew.sh).";
  exit 1;
fi

brew cleanup
