#!/usr/bin/env sh
#
# Handy shell scriopt to unlock the Boulder office front door. This script only
# works when connected to the local network.
echo 'unlock' | nc -G 1 192.168.128.9 12345