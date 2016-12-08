# ==== Ruby Setup ====

export RUBY_HOME="${SRC_PATH}/ruby"

function rb() {
  if [ -n "$1" ]; then
    cd ${RUBY_HOME}/$1
  else
    cd ${RUBY_HOME}
  fi
}

function _rb() {
  dirs=`find ${RUBY_HOME} -type d -depth 1 -maxdepth 1 | cut -d/ -f6`
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _rb rb
