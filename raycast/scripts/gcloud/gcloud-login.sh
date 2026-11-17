#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Login
# @raycast.mode fullOutput
# @raycast.packageName GCloud
#
# Optional parameters:
# @raycast.icon 🫯
#
# Documentation:
# @raycast.description GCloud Auth Login
# @raycast.author tim.pease
# @raycast.authorURL https://twitter.com/1872Fate

if ! command -v gcloud &> /dev/null; then
  echo "gcloud command is required (https://cloud.google.com/cli/).";
  exit 1;
fi

gcloud auth login
