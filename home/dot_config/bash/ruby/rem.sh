#!/bin/sh

_ruby_version() {
  asdf current ruby 2> /dev/null | awk '{print $2}'
}

_rem_show() {
  echo "ruby version: $(_ruby_version)"
  echo "gem home:     ${GEM_HOME}"
}

_rem_reset() {
  if [ -z "${REM_ORIG_GEM_HOME:-}" ]; then
      unset GEM_HOME
  else
      export GEM_HOME="${REM_ORIG_GEM_HOME}"
  fi

  if [ -z "${REM_ORIG_GEM_PATH:-}" ]; then
    unset GEM_PATH
  else
    export GEM_PATH="${REM_ORIG_GEM_PATH}"
  fi

  if [ -n "${REM_ORIG_PATH:-}" ]; then
    export PATH="${REM_ORIG_PATH}"
  fi

  unset REM_ROOT
  unset REM_ORIG_GEM_PATH
  unset REM_ORIG_GEM_HOME
  unset REM_ORIG_PATH

  echo "environment has been reset"
  _rem_show
}

_rem_setup() {
  if [ -z "${REM_ORIG_PATH:-}" ]; then
    export REM_ORIG_GEM_HOME="${GEM_HOME:-}"
    export REM_ORIG_GEM_PATH="${GEM_PATH:-}"
    export REM_ORIG_PATH="${PATH:-}"
  fi

  REM_ROOT="$(pwd)"
  export REM_ROOT
  gem_dir="${REM_ROOT}/vendor/gems/$(_ruby_version)"

  export GEM_HOME="${gem_dir}"
  export GEM_PATH="${gem_dir}:${REM_ORIG_GEM_PATH}"
  export PATH="${gem_dir}/bin:${REM_ORIG_PATH}"

  _rem_show
}

rem() {
  version="${1:-}"

  if [ -z "$version" ] && [ -f ".tool-versions" ]; then
    version="$(grep "^ruby " ".tool-versions" | sed -e "s/^ruby //")"
  fi

  if [ "$version" = "--help" ] || [ "$version" = "-h" ] || [ -z "$version" ]; then
    echo "Usage: rem <version>|reset|show|versions"
    echo
    echo "  Switches gem home to a local vendor directory."
    echo "  The 'default' option uses the global asdf ruby version."
    echo "  Otherwise the supplied ruby version will be used."
    echo "  Use 'reset' to go back to normal."
    echo
    return

  elif [ "$version" = "show" ]; then
    _rem_show
    return

  elif [ "$version" = "reset" ]; then
    _rem_reset
    return

  elif [ "$version" = "versions" ]; then
    asdf list ruby
    return

  else
    asdf local ruby "$version"
    _rem_setup
  fi
}
