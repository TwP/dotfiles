# .aliases

# setup aliases
#---------------
alias ..='cd ..'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias b='cd $OLDPWD'
alias c='clear'
alias ds='/usr/bin/du -h -s'
alias du='/usr/bin/du -h'
alias find='/usr/bin/find'

alias gdf='git difftool -y'
alias gdh='git diff HEAD'
alias git-doc="heel -r $HOMEBREW/share/doc/git-doc"
alias gka='gitk --all 2>&1 > /dev/null &'
alias gsd='git svn dcommit'
alias gsr='git svn rebase'
alias gst='git status'
alias gitx='/Applications/GitX.app/Contents/MacOS/GitX > /dev/null 2>&1 &'

alias l.='/bin/ls -lFdh .*'
alias ls='/bin/ls -F'
alias ll='/bin/ls -lFh'
alias la='/bin/ls -laFh'
alias lrt='/bin/ls -lrtFh'
alias lart='/bin/ls -lartFh'

alias lg='cd ~/work/logtastic'

#alias ls='/bin/ls -F'
#alias ll='/bin/ls -laFh'
#alias lart='/bin/ls -lartF'

alias pd='pushd'
alias pp='popd'

alias scr='screen -D -R'
alias scl='screen -list'

alias show='set | grep'
alias sudo='/usr/bin/sudo -p "[sudo] password for %u: "'
alias vim="$DOTS/bin/mvim"

alias tomcat-start="$CATALINA_HOME/bin/startup.sh"
alias tomcat-stop="$CATALINA_HOME/bin/shutdown.sh"

alias mysqlstart='sudo mysqld_safe &'
alias mysqlstop='mysqladmin -u root -p shutdown'
alias mysqlstatus='ps -ax | grep mysql'

alias nb='cd ~/Dropbox/Tim/notebook'

PG_CTL="sudo -u postgres -- $PSQL_HOME/bin/pg_ctl"
PG_DB="$MACPORTS/var/db/postgresql90/defaultdb"
alias pgstart="$PG_CTL start -D $PG_DB"
alias pgstop="$PG_CTL stop -D $PG_DB"
alias pgstatus="$PG_CTL status -D $PG_DB"

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
    read -sn1
    kill $pid; wait $pid
} 2>/dev/null

function p {
    if [ -n "$1" ]; then
        ps -O ppid -U $USER | grep -v grep | grep "$1"
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

function findr {
    find . -name '*.rb' -print0 | xargs -0 grep "$*"
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

function g { cd ~/GitHub/$@; }

# These are some functions that are useful for dealing with git branches
# ----------------------------------------------------------------------

# This function returns the name of the current git branch
function gitb {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# This function updates the current branch with the latest changes from the
# origin repository. The master branch is checked out, a git pull is performed,
# the original branch is checked out again, and then the changes from master
# are rebased back into the branch.
#
# Essentially, the following steps are performed. The command is smart enough
# to do the right thing when the current branch _is_ the master branch.
#
#   git checkout master
#   git pull --rebase
#   git checkout $branch
#   git rebase master
#
function gitu {
    branch=`gitb`
    if [ "$branch" != "master" ]; then
        git checkout master
    fi
    git pull --rebase
    if [ "$branch" != "master" ]; then
        git checkout "$branch"
        git rebase master
    fi
}

# This function pushes the changes from the current branch up to the origin
# repository. The master branch is checked out and the changes from the
# original branch are rebased into the master branch. After this, all changes
# are pushed to the origin repository. The original branch is checked out
# again.
#
# Essentially, the following steps are performed. The command is smart enough
# to do the right thing when the current branch _is_ the master branch.
#
#   git checkout master
#   git rebase $branch
#   git push
#   git checkout $branch
#
function gitp {
    branch=`gitb`
    if [ "$branch" != "master" ]; then
        git checkout master
        git rebase "$branch"
    fi
    git push
    if [ "$branch" != "master" ]; then
        git checkout "$branch"
    fi
}

# This function calls the "gitu" and the "gitp" functions in succession. This
# pulls in changes from the master branch to the current branch, and then
# pushes all changes from the current branch up to the origin repository. This
# combination of commands keeps the master branch revision history nice and
# linear.
#
function gitup {
    gitu
    gitp
}

#function parse_git_branch {
#  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
#}

#function git_dirty_flag {
#  git status 2> /dev/null | grep -c : | awk '{if ($1 > 0) print " ⚡"}'
#}

# Work Environment Functions
# --------------------------
sg () {
  DIR=~/work/ruby
  export RUBYLIB=$DIR/webby/lib:$DIR/logging/lib
  cd ~/work/seagate/Tools/fdm
}

wb () {
#  DIR=~/work/ruby
#  export RUBYLIB=$DIR/webby/lib
  cd ~/work/ruby/webby
}

wbsite () {
#  DIR=~/work/ruby
#  export RUBYLIB=$DIR/webby/lib
  cd ~/work/ruby/webby/examples/webby
}

pea53 () {
#  DIR=~/work/ruby
#  export RUBYLIB=$DIR/webby/lib
  cd ~/work/html/pea53
}

# Mandelbrot
# ----------
mb () {
    if [ -z "$1" ]; then
        cd "$HOME/work/mb"
    else
        cd "$HOME/work/mb/$1"
    fi
    return 0
}

# Database Functions
# ------------------
alias sqldev2='mysql5 -hdev2 -uadmin -padmin --database=ci_sentiment_db --prompt="[\u@\h] mysql> "'
alias sqldev3='mysql5 -hdev3 -uadmin -padmin --database=ci_sentiment_db --prompt="[\u@\h] mysql> "'
ciro () { mysql5 -u ciro -h 10.10.12.100 -D ci_sentiment_db -p; }

# Colorize Functions
# ------------------
cmake   () { make $* 2>&1 | awk -f $DOTS/bin/make.awk; }

#check   () { cvs -n up $* 2>&1 | awk -f $DOTS/bin/cvs.awk; }
#cvsup   () { cvs up -Pd $* 2>&1 | awk -f $DOTS/bin/cvs.awk; }
#cvsdiff () { cvs diff -c $* 2>&1 | awk -f $DOTS/bin/cdiff.awk; }

cdiff    () { diff -c $* 2>&1 | awk -f $DOTS/bin/cdiff.awk; }

check    () { svn st $* 2>&1 | awk -f $DOTS/bin/svn.awk; }
svnup    () { svn up $* 2>&1 | awk -f $DOTS/bin/svn.awk; }
svndiff  () { svn diff $* -x -c 2>&1 | awk -f $DOTS/bin/cdiff.awk; }
update   () { svn up $* 2>&1 | awk -f $DOTS/bin/svn.awk; }
sdiff    () { svn diff $* -x -c 2>&1 | awk -f $DOTS/bin/cdiff.awk; }

# rsync Functions
# ---------------

Push () {
    rsync.rb push $*
}

Pull () {
    rsync.rb pull $*
}

#Get () {
#    dir=`pwd`
#    puter=$1; shift
#    rsync $* -v -rulptzCF ${puter}:${dir}/ ${dir}/
#}

#Put () {
#    dir=`pwd`
#    puter=$1; shift
#    rsync $* -v -rulptzCF ${dir}/ ${puter}:${dir}/
#}

#Pull () {
#    dir=`pwd`
#    rsync $* -v -rulptzCF ${PUTER}:${dir}/ ${dir}/
#}

#Push () {
#    dir=`pwd`
#    rsync $* -v -rulptzCF ${dir}/ ${PUTER}:${dir}/
#}

# EOF
