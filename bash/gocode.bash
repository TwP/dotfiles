# ==== GO Development Setup ====
# All the fucntions useful for working with GO

GOPATH=$(go env GOPATH)
[ -d "${HOME}/.go" ] && GOPATH="${HOME}/.go"
[ -d "${SRC_PATH}/gocode" ] && GOPATH="${SRC_PATH}/gocode"
export GOPATH
export GO111MODULE="auto"

# ==== PATH setup ====
[ -d $GOPATH ] && PATH="$GOPATH/bin:$PATH"
export PATH

function goto() {
  if [ -n "$1" ]; then
    cd ${GOPATH}/src/$1
  else
    cd ${GOPATH}/src
  fi
}

function _goto() {
  declare -A dirs_map
  dirs=`find ${GOPATH}/src -type d -depth 3 -maxdepth 3 | cut -d/ -f7,8,9`
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _goto goto
