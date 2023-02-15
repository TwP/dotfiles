# ==== EOI Setup ====

EOI_HOME="${HOME}/eoi"

function eoi() {
  if [ -n "$1" ]; then
    cd "${EOI_HOME}/$1"
  else
    cd "${EOI_HOME}"
  fi
}

function _eoi() {
  dirs=$(find "${EOI_HOME}" -type d -depth 1 -maxdepth 1 | cut -d/ -f5)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _eoi eoi
