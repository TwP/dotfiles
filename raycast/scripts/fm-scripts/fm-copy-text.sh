#!/bin/bash
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Text
# @raycast.mode silent
# @raycast.packageName Foundation Models
#
# Optional parameters:
# @raycast.icon 🤖
#
# Documentation:
# @raycast.description Copy Text from a Screen Capture to the Clipboard
# @raycast.author tim.pease
set -euo pipefail

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/fm-copy-text.XXXXXXXXXX")
# bash runs the EXIT trap on normal exit, set -e failures, and fatal signals (TERM/HUP)
trap 'rm -rf -- "$tmpdir"' EXIT
f=$tmpdir/frame.png

screencapture -i "$f"
[[ -s $f ]] || exit 0   # selection cancelled

# capture first so a failure or timeout doesn't clobber the clipboard
text=$(perl -e 'alarm 40; exec @ARGV' fm respond --tool "ocr" --image "$f" \
  --guardrails "permissive-content-transformations" \
  -i "Print only what the getText tool returns with nothing added." \
  "Use the getText tool.") || { echo "OCR failed"; exit 1; }
[[ -n $text ]] || { echo "No text found"; exit 0; }

printf '%s' "$text" | pbcopy
echo "Text copied"
