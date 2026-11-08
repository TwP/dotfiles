#!/bin/bash
# ==== Neovim / Neovide Setup ====

export NEOVIDE_FORK=1
export NEOVIDE_NO_MULTIGRID=1
export NEOVIDE_ICON="$HOME/.config/neovide/Neovide.icns"

alias nv="neovide --reuse-instance --new-window"
