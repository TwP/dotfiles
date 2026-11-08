# ==== GO Development Setup ====
# All the fucntions useful for working with GO

if command -v go > /dev/null 2>&1; then
  GOPATH=$(go env GOPATH)
fi
[ -d "${HOME}/.go" ] && GOPATH="${HOME}/.go"
export GOPATH
export GO111MODULE="auto"

# ==== PATH setup ====
[ -d "$GOPATH" ] && PATH="$GOPATH/bin:$PATH"
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
  dirs=$(find "${GOCODE}" -type d -depth 1 -maxdepth 1 | cut -d/ -f6)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}
complete -F _goto goto

function gotest() {
  go test "$@"
}

function _gotest() {
  pkgs=$(go list ./...)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$pkgs" -- $cur) )
}
complete -F _gotest gotest
