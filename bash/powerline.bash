#!/usr/bin/env bash
#
# Based on the bash powerline work done by @riobard
# https://github.com/riobard/bash-powerline
#
# This prompt requires the patched Fira Code (or Mono) font found here:
# https://github.com/ryanoasis/nerd-fonts/
#
# A handy guide to color codes and formatting in bash
# http://misc.flogisoft.com/bash/tip_colors_and_formatting
# http://www.linuxjournal.com/content/return-values-bash-functions
#
# Inspiration: https://github.com/bhilburn/powerlevel9k
#              https://github.com/jaspernbrouwer/powerline-gitstatus
#

__powerline() {

  # Unicode glyphs
  readonly PS_SYMBOL_MACOS=''    # apple logo          U+E711
  readonly PS_SYMBOL_FOLDER=''   # octicons folder     U+F413
  readonly PS_SYMBOL_CLOCK=''    # fontawesome clock   U+F017
  readonly PS_SYMBOL_HOUSE=''    # fontawesome house   U+F015

  readonly GIT_SYMBOL_BRANCH=''  # octicons git branch    U+F418
  readonly GIT_SYMBOL_CHANGES='' # fontawesome bolt       U+F0E7
  readonly GIT_SYMBOL_PUSH=''    # fontawesome up arrow   U+F176
  readonly GIT_SYMBOL_PULL=''    # fontawesome down arrow U+F175

  readonly SEPARATOR=''          # powerline right-pointing triangle U+E0B0
  readonly LEADER='╭'             # light arc down and right U+256D
  readonly TRAILER='╰➝'           # light arc up and right U+2570 / triangle-headed rightwards arrow U+279D

  source ${DOTS}/bash/prompt-colors.sh

  __git_info() {
    [ -x "$(which git)" ] || return

    local git_eng="env LANG=C git"   # force git output in English to make our work easier
    # get current branch name or short SHA1 hash for detached head
    local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
    [ -n "$branch" ] || return  # git branch not found

    local marks

    # branch is modified?
    [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_SYMBOL_CHANGES"

    # how many commits local branch is ahead/behind of remote?
    local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    [ -n "$aheadN" ] && marks+=" $GIT_SYMBOL_PUSH$aheadN"
    [ -n "$behindN" ] && marks+=" $GIT_SYMBOL_PULL$behindN"

    printf "${GIT_SYMBOL_BRANCH} ${branch}${marks}"
  }

  ps1() {
    if [ $? -eq 0 ]; then
      local FG_EXIT=$FG_GREEN
      local FG_APPLE=$FG_GREY
    else
      local FG_EXIT=$FG_RED
      local FG_APPLE=$FG_RED
    fi

    local FG_SEP

    PS1="${FG_EXIT}${LEADER}${RESET} ${FG_APPLE}${PS_SYMBOL_MACOS} ";                           FG_SEP=$FG_BLACK
    PS1+="${FG_SEP}${BG_GREY}${SEPARATOR}${FG_BLACK} ${PS_SYMBOL_CLOCK}  $(date "+%H:%M:%S") "; FG_SEP=$FG_GREY
    PS1+="${FG_SEP}${BG_CYAN}${SEPARATOR}${FG_BLACK} ${PS_SYMBOL_FOLDER}  \w ";                 FG_SEP=$FG_CYAN

    if git -C . rev-parse 2>/dev/null; then
      __powerline_git_info="$(__git_info)"
      PS1+="${FG_SEP}${BG_GREEN}${SEPARATOR}${FG_BLACK} \${__powerline_git_info} "
      FG_SEP=$FG_GREEN
    fi

    PS1+="${FG_SEP}${BG_BLACK}${SEPARATOR}${RESET}\n"
    PS1+="${FG_EXIT}${TRAILER}${RESET} "

    # set the title bar to show the hostname and current working directory
    echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"
  }

  PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
