# ==== EOI Setup ====

EOI_HOME="${HOME}/work/eoi"
AWS_PROFILE="eoi-dev-software"
export AWS_PROFILE

function aws_login() {
  if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "Logging into AWS profile '${AWS_PROFILE}'"
    aws sso login --profile "${AWS_PROFILE}"
   else
    echo "Logged in profile '${AWS_PROFILE}'"
   fi
   AWS_REGION="$(aws configure get region)"
   export AWS_REGION
}

function eoi() {
  if [ -n "$1" ]; then
    cd "${EOI_HOME}/$1"
  else
    cd "${EOI_HOME}"
  fi
}

function _eoi() {
  dirs=$(find "${EOI_HOME}" -type d -depth 1 -maxdepth 1 | cut -d/ -f5)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _eoi eoi
