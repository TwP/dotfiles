# ———— IonQ Setup ————
export IONQ_HOME="${HOME}/ionq"

# ———— PATH setup ————
[ -d "$IONQ_HOME/cloud-agent/bin" ] && PATH="$IONQ_HOME/cloud-agent/bin:$PATH"
[ -d "$HOMEBREW_PREFIX/share/google-cloud-sdk/bin" ] && PATH="$HOMEBREW_PREFIX/share/google-cloud-sdk/bin:$PATH"
export PATH

# ———— GCP Kubernetes Setup ————
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# ———— functions & aliases ————
function iq() {
  if [ -n "$1" ]; then
    cd "${IONQ_HOME}/$1"
  else
    cd "${IONQ_HOME}"
  fi
}

function _iq() {
  dirs=$(find "${IONQ_HOME}" -type d -depth 1 -maxdepth 1 | cut -d/ -f5)
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$dirs" -- $cur) )
}

complete -F _iq iq

# Completions for the `csp` cloud-sql-proxy helper script
function _csp() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  case "$prev" in
    staging|prod|all)
      COMPREPLY=( $(compgen -W "us eu all" -- "$cur") )
      ;;
    *)
      COMPREPLY=( $(compgen -W "staging prod all" -- "$cur") )
      ;;
  esac
}

complete -F _csp csp

# Helper function that retrieves a Jira ticket and creates a markdown
# file in the Obsidian notebook. Will overwrite any existing files so
# use with caution.
function jitoob() {
  local key="${1:-}"
  local obsidian_dir="$HOME/Documents/Notebook/❷ Areas/Tasks"

  if [ -z "$key" ]; then
    echo "Please provide a Jira ticket: QTPF-123"
  else
    echo "Creating markdown file: $obsidian_dir/$key.md"
    jira view "$key" -t obsidian > "$obsidian_dir/$key.md"
  fi
}
