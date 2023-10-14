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
