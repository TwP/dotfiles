# .aliases

# setup aliases
#---------------
alias ..='cd ..'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias b='cd $OLDPWD'
alias c='clear'
alias du='/usr/bin/du -h'
alias find='/usr/bin/find'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias gti='git'

alias l.='/bin/ls -lFdh .*'
alias ls='/bin/ls -F'
alias ll='/bin/ls -lFh'
alias la='/bin/ls -laFh'
alias lrt='/bin/ls -lrtFh'
alias lart='/bin/ls -lartFh'

alias pd='pushd'
alias pp='popd'

alias scr='screen -D -R'
alias scl='screen -list'

alias show='set | grep'
alias sudo='/usr/bin/sudo -p "[sudo] password for %u: "'

alias utc='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias unix='date -u +"%s"'

alias vi="$HOMEBREW_ROOT/bin/vim"

alias keyboard='ioreg -n IOHIDKeyboard -r | grep -e "class IOHIDKeyboard" -e VendorID\" -e Product'

# use to turn wi-fi on and off
# `wifi on` and `wifi off`
alias wifi='networksetup -setairportpower en0'

# open a file using the Marked application
alias marked='open -a Marked'

# search for system icons
function icons {
  find /System/Library -iname '*.icns' -o -iname '*.tiff' -o -iname '*.png' 2>/dev/null | grep -i "$1[^/]*$"
}

function stuff {
  if [ -z "$1" ]; then
    echo "Usage: stuff [folder]"
    echo "  Compress the given 'folder' into a gzipped tar archive"
    return 1
  fi

  if [ -f "$1.tgz" ]; then
    echo "  Stuffed file '$1.tgz' already exists"
    return 1
  else
    echo "  Creating '$1.tar'"
    tar -cvf "$1.tar" "$1"
    echo "  Compressing '$1.tar'"
    gzip -9 "$1.tar"
    mv "$1.tar.gz" "$1.tgz"
    echo "  Created '$1.tgz'"
  fi
}

function ql {
  qlmanage -p "$@" & pid=$!
  read -rsn1
  kill $pid; wait $pid
} 2>/dev/null

function psg {
  ps wwwaux | grep -E "($1|%CPU)" | grep -v grep
}

function p {
  if [ -n "$1" ]; then
    ps -O ppid -U $USER | grep -i "$1" | grep -v grep
  else
    ps -O ppid -U $USER
  fi
}

function pkill {
  if [ -z "$1" ]; then
    echo "Usage: pkill [process name]"
    return 1
  fi

  local pid
  pid=$(p $1 | awk '{ print $1 }')

  if [ -n "$pid" ]; then
    echo -n "Killing \"$1\" (process $pid)..."
    kill -sigkill $pid
    echo "done."
  else
    echo "Process \"$1\" not found."
  fi
}

function pint {
  if [ -z "$1" ]; then
    echo "Usage: pint [process name]"
    return 1
  fi

  local pid
  pid=$(p $1 | awk '{ print $1 }')

  if [ -n "$pid" ]; then
    echo -n "Sending INT to \"$1\" (process $pid)..."
    kill -sigint $pid
    echo "done."
  else
    echo "Process \"$1\" not found."
  fi
}

# helper function to codesign brew packages and add them to the firewall rules
function csign {
  if [ -z "$1" ]; then
    echo "Usage: csign [brew formuula name]"
    return 1
  fi

  BINARY=$(brew info "$1" | grep "^${HOMEBREW_ROOT}.*\*\$" | sed -e "s/\\([^ ]*\\).*$/\\1\\/bin\\/$1/")

  # create an ad-hoc signature for the homebrew managed application
  /usr/bin/codesign -f -s - "$BINARY"

  # add the application to the firewall
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$BINARY"
}

# find a ruby class or module of the given name
function agcm {
  ag "(class|module)\s+.*\b$1\b"
}

function findr {
  find . -name '*.rb' -print0 | xargs -0 grep "$*"
}

function cdiff {
  diff -c "$1" "$2" 2>&1 | awk -f "$DOTS/bash/cdiff.awk"
}

function garmin {
  orig="/Volumes/GARMIN/Garmin/Activities"
  dest="${HOME}/Sync/Tim/Garmin Activities/$(date '+%Y')"
  mkdir -p "${dest}"
  mv ${orig}/* "${dest}" && diskutil unmount GARMIN
}

# from Tammer Saleh (http://tammersaleh.com/posts/useful-macvim-script)
function v {
  if [ $# == 0 ] ; then
    mvim
  else
    mvim --servername $(basename $(pwd)) \
         --remote-tab-silent "$@" 1>/dev/null 2>&1
  fi
}

# from Nathan Witmer
alias scan-ssh='dns-sd -B _ssh._tcp'

function ssh-setup {
  ssh $1 'mkdir -p -m 700 .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys';
  cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

# Enable a yubikey via the yubiswitch application if it is installed
function enable-yubikey() {
  ps ux | grep [y]ubiswitch >/dev/null && osascript -e 'tell application "yubiswitch" to KeyOn'
}
