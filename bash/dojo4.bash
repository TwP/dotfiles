# ==== Ruby Setup ====

DOJO4_HOME="${SRC_PATH}/Dojo4"

function dj() {
  if [ -n "$1" ]; then
    cd ${DOJO4_HOME}/$1
  else
    cd ${DOJO4_HOME}
  fi
}

function _dj() {
  dirs=`find ${DOJO4_HOME} -type d -depth 1 -maxdepth 1 | cut -d/ -f6`
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _dj dj
