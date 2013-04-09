# .ruby.bash

function rbenv_version {
  rbenv version 2> /dev/null | sed 's/\([^ ]*\).*/\1/'
}
alias ruby_version=rbenv_version

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

  unset RBM_ORIG_GEM_PATH
  unset RBM_ORIG_GEM_HOME
  unset RBM_ORIG_PATH
  unset RBENV_VERSION
}

function rbenv_manager_setup {
  if [ -z "${RBM_ORIG_PATH}" ]; then
    export RBM_ORIG_GEM_HOME=${GEM_HOME:-}
    export RBM_ORIG_GEM_PATH=${GEM_PATH:-}
    export RBM_ORIG_PATH=${PATH:-}
  fi

  local gem_dir="$(pwd)/vendor/gems/$(rbenv_version)"

  export GEM_HOME=${gem_dir}
  export GEM_PATH=${gem_dir}:${RBM_ORIG_GEM_PATH}
  export PATH=${gem_dir}/bin:${RBM_ORIG_PATH}
}

function rbenv_manager {
  local version=${1:-}

  if [ -z "$version" ]; then
    echo "usage: rbenv_manager <version>|default|reset"
    echo
    echo "  Switches gem home to a local vendor directory."
    echo "  The 'default' option uses the global rbenv ruby version."
    echo "  Otherwise the supplied ruby version will be used."
    echo "  Use 'reset' to go back to normal."
    echo
    return
  elif [ $version = "reset" ]; then
    rbenv_manager_reset
    return
  else
    if [ $version == "default" ]; then
      unset RBENV_VERSION
    else
      rbenv shell $version
    fi

    rbenv_manager_setup

    if [ -x "script/bootstrap" ]; then
      ./script/bootstrap
    fi
  fi
}
alias rbm=rbenv_manager
