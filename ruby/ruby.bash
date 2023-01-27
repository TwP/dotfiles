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

source "$DOTS/ruby/rem.sh"
source "$DOTS/ruby/bash_completion"
