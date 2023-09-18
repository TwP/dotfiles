# ==== Rust Development Setup ====
# All the fucntions useful for working with Rust

export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

# ==== PATH setup ====
[ -d "$CARGO_HOME" ] && PATH="$CARGO_HOME/bin:$PATH"
export PATH

if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
fi

# function goto() {
#   if [ -n "$1" ]; then
#     cd ${GOPATH}/src/$1
#   else
#     cd ${GOPATH}/src
#   fi
# }

# function _goto() {
#   declare -A dirs_map
#   dirs=`find ${GOPATH}/src -type d -depth 3 -maxdepth 3 | cut -d/ -f7,8,9`
#   local cur=${COMP_WORDS[COMP_CWORD]}
#   COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
# }

# complete -F _goto goto
