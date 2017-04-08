# network.bash
#
# This is a collection of functions useful for working with Apple's
# `networksetup` command line tool. This tool enables you to configure network
# devices, bridges, and wifi connections all from the command line.

function _networksetup() {
  cmds=$(/usr/sbin/networksetup -printcommands | awk '{print $2}')
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$cmds" -- $cur) )
}

complete -F _networksetup networksetup

# vim:ft=sh
