# .ruby.bash

function rbenv_version {
  rbenv version 2> /dev/null | sed 's/\([^ ]*\).*/\1/'
}
alias ruby_version=rbenv_version

function rbenv_manager_show {
  echo "ruby version: $(rbenv_version)"
  echo "gem home:     ${GEM_HOME}"
}

function rbenv_manager_current {
  if [ -z "${RBM_ROOT}" ]; then
    return 2
  elif [ `expr $(pwd) : ${RBM_ROOT}` == "0" ]; then
    return 0
  else
    return 1
  fi
}

function rbenv_manager_reset {
  if [ -z "${RBM_ORIG_GEM_HOME}" ]; then
      unset GEM_HOME
  else
      export GEM_HOME=${RBM_ORIG_GEM_HOME}
  fi

  if [ -z "${RBM_ORIG_GEM_PATH}" ]; then
    unset GEM_PATH
  else
    export GEM_PATH=${RBM_ORIG_GEM_PATH}
  fi

  if [ -n "${RBM_ORIG_PATH}" ]; then
    export PATH=${RBM_ORIG_PATH}
  fi

  unset RBM_ROOT
  unset RBM_ORIG_GEM_PATH
  unset RBM_ORIG_GEM_HOME
  unset RBM_ORIG_PATH
  unset RBENV_VERSION

  echo "environment has been reset"
  rbenv_manager_show
}

function rbenv_manager_setup {
  if [ -z "${RBM_ORIG_PATH}" ]; then
    export RBM_ORIG_GEM_HOME=${GEM_HOME:-}
    export RBM_ORIG_GEM_PATH=${GEM_PATH:-}
    export RBM_ORIG_PATH=${PATH:-}
  fi

  export RBM_ROOT=$(pwd)
  local gem_dir="${RBM_ROOT}/vendor/gems/$(rbenv_version)"

  export GEM_HOME=${gem_dir}
  export GEM_PATH=${gem_dir}:${RBM_ORIG_GEM_PATH}
  export PATH=${gem_dir}/bin:${RBM_ORIG_PATH}

  rbenv_manager_show
}

function rbenv_manager {
  local version=${1:-}

  if [ "$version" == "--help" -o "$version" == "-h" ]; then
    echo "usage: rbenv_manager <version>|reset|show|versions"
    echo
    echo "  Switches gem home to a local vendor directory."
    echo "  The 'default' option uses the global rbenv ruby version."
    echo "  Otherwise the supplied ruby version will be used."
    echo "  Use 'reset' to go back to normal."
    echo
    return

  elif [ "$version" == "show" ]; then
    rbenv_manager_show
    return

  elif [ "$version" == "reset" ]; then
    rbenv_manager_reset
    return

  elif [ "$version" == "versions" ]; then
    rbenv versions
    return

  else
    if [ -z "$version" ]; then
      unset RBENV_VERSION
    else
      rbenv shell $version
    fi

    rbenv_manager_setup
  fi
}

function _rbm() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local rubies=$(rbenv completions global "$cur")
  COMPREPLY=( $(compgen -W "$rubies" -- "$cur") )
}

alias rbm=rbenv_manager
complete -F _rbm rbm
