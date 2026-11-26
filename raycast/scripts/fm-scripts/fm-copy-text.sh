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

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/screen.XXXXXXXXXX")
f=$tmpdir/frame.png

cleanup() {
    rc=$?                    # must be the first statement
    trap - EXIT INT TERM HUP # disarm, so a failure in cleanup can't recurse
    rm -rf -- "$tmpdir"
    exit "$rc"
}

trap cleanup EXIT
# turn catchable signals into a normal exit so cleanup always runs
for s in HUP INT TERM; do
    trap "exit $((128 + $(kill -l "$s")))" "$s"
done

screencapture -i "$f"
[ -s "$f" ] || exit 0
perl -e 'alarm 40; exec @ARGV' fm respond --tool "ocr" --image "$f" \
  -i "Print only what the getText tool returns with nothing added." \
  "Use the getText tool." | pbcopy

echo "Text copied"
