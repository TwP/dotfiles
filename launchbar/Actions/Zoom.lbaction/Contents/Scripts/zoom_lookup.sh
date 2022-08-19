#!/usr/bin/env bash
set -Eeu -o pipefail

curl -s -i -HEAD "$1" | grep '^location: ' | cut -c 11-
