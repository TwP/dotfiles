# ==== Docker Setup ====
# Some fucntions useful for working with Docker

alias dpsa="docker ps -a"
alias dv="docker volume ls"
alias dn="docker network ls"

function _dc() {
  local cmds="activate clean console cycle deactivate ports prune ready rebuild screen"
  local cur=${COMP_WORDS[COMP_CWORD]}
  _docker_compose
  COMPREPLY=( $(compgen -W "$cmds" -- $cur) "${COMPREPLY[@]}" )
}

complete -F _dc dc
