# completions.bash
#
# This is a collection of bash completion functions for various commands.


# Completions for Apple's `networksetup` command line tool. This tool enables
# you to configure network devices, bridges, and wifi connections all from the
# command line.
function _networksetup() {
  cmds=$(/usr/sbin/networksetup -printcommands | awk '{print $2}')
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$cmds" -- $cur) )
}
complete -F _networksetup networksetup

# Completions for our `gh-creds` token management script.
function _gh-creds() {
  local cmds="erase help setup show token user"
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$cmds" -- $cur) )
}
complete -F _gh-creds gh-creds
