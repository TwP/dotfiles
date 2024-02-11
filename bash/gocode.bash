# ==== GO Development Setup ====
# All the fucntions useful for working with GO

GOPATH=$(go env GOPATH)
[ -d "${HOME}/.go" ] && GOPATH="${HOME}/.go"
export GOPATH
export GO111MODULE="auto"

# ==== PATH setup ====
[ -d $GOPATH ] && PATH="$GOPATH/bin:$PATH"
export PATH

GOCODE="${SRC_PATH}/gocode"

function goto() {
  if [ -n "$1" ]; then
    cd "${GOCODE}/$1"
  else
    cd "${GOCODE}"
  fi
}

function _goto() {
  declare -A dirs_map
  dirs=$(find "${GOCODE}" -type d -depth 1 -maxdepth 1 | cut -d/ -f6)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _goto goto
