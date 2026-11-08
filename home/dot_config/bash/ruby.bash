#!/bin/bash
# ==== Ruby Setup ====

export RUBY_HOME="${SRC_PATH}/ruby"

rb() {
  if [ -n "$1" ]; then
    cd "$RUBY_HOME/$1"
  else
    cd "$RUBY_HOME"
  fi
}

source "$HOME/.config/bash/ruby/rem.sh"
source "$HOME/.config/bash/ruby/bash_completion"
