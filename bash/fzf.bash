# Setup fzf
# ---------
if [[ ! "$PATH" == "*$HOMEBREW_ROOT/opt/fzf/bin*" ]]; then
  export PATH="$PATH:$HOMEBREW_ROOT/opt/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == "*$HOMEBREW_ROOT/opt/fzf/man*" && -d "$HOMEBREW_ROOT/opt/fzf/man" ]]; then
  export MANPATH="$MANPATH:$HOMEBREW_ROOT/opt/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOMEBREW_ROOT/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOMEBREW_ROOT/opt/fzf/shell/key-bindings.bash"
