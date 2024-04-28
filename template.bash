#!/usr/bin/env bash
#/ Usage: SCRIPTNAME <command> [options]
#/
#/   Put the description of what your script will do here. The two sections
#/   below describe the commands and options that your script will accept.
#/   You can skip the commands section if your script only accepts options,
#/   but please do provide some example usage.
#/
#/   COMMANDS:
#/     register  <email>      Register a new email address
#/     renew                  Renew the registration
#/
#/   OPTIONS
#/     -h, --help         Show this help message
#/     -v, --verbose      Print script debug info
#/
#/   EXAMPLE:
#/     SCRIPTNAME -v register sally@example.com
#/     SCRIPTNAME renew
#/     SCRIPTNAME --help
#/     SCRIPTNAME
#/
#------------------------------------------------------------------------------
set -o errexit
set -o nounset
if [ "${TRACE:-0}" -eq "1" ]; then
  set -o xtrace
fi

usage() {
  grep "^#/" "$0" | cut -c 4-
}

parse_params() {
  command=''

  while :; do
    case "${1:-}" in
    -h | --help ) usage && exit ;;
    -v | --verbose ) set -o xtrace ;;
    register | renew) command="$1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")
}

register() {
  echo "\`register\` called with args: $*"
}

renew() {
  echo "\`renew\` called with args: $*"
}

parse_params "$@"

if [ -n "${command}" ]; then
  ${command} "${args[*]}"
else
  usage
fi

#
# Ideas in this template taken from these source
# - https://sharats.me/posts/shell-script-best-practices/
# - https://betterdev.blog/minimal-safe-bash-script-template/
#