# cvs.awk
#
# This is an nawk script used to colorize the output from cvs.   Simply pipe
# the output from cvs operations into the nawk (or gawk) program with this
# file as the awk script.
#
# Examples:
#    cvs -q up -Pd 2>&1 | nawk -f cvs.awk
#
# Functions:
#    check () { cvs -q -n up -Pd $* 2>&1 | nawk -f cvs.awk; }
#    cvsup () { cvs -q    up -Pd $* 2>&1 | nawk -f cvs.awk; }
# -----------------------------------------------------------------------------

BEGIN {

# Define the colors in our color pallete
# --------------------------------------
    normal       = "\033[0m"
    boldon       = "\033[1m"
    italicson    = "\033[3m"
    underlineon  = "\033[4m"
    inverseon    = "\033[7m"
    strikethon   = "\033[9m"
    boldoff      = "\033[22m"
    italicsoff   = "\033[23m"
    underlineoff = "\033[24m"
    inverseoff   = "\033[27m"
    strikethoff  = "\033[29m"
    fgblack      = "\033[30m"
    fgred        = "\033[31m"
    fggreen      = "\033[32m"
    fgyellow     = "\033[33m"
    fgblue       = "\033[34m"
    fgmagenta    = "\033[35m"
    fgcyan       = "\033[36m"
    fgwhite      = "\033[37m"
    fgdefault    = "\033[39m"
    bgblack      = "\033[40m"
    bgred        = "\033[41m"
    bggreen      = "\033[42m"
    bgyellow     = "\033[43m"
    bgblue       = "\033[44m"
    bgmagenta    = "\033[45m"
    bgcyan       = "\033[46m"
    bgwhite      = "\033[47m"
    bgdefault    = "\033[49m"
}

# Unknown
#
/^\? / { print boldon fgwhite $0 normal; next }

# Needs Update
#
/^[UP] / { print boldon fggreen $0 normal; next }

# Modified
#
/^M / { print boldon fgmagenta $0 normal; next }

# Added
#
/^A / { print boldon fgcyan $0 normal; next }

# Removed
#
/^R / { print boldon fgred $0 normal; next }

# Conflict
#
/^C / { print boldon fgwhite bgred $0 normal; next }

# Tag
#
/^T / { print fgred $0 normal; next } 

# Merge warning
#
/^Merging/ { print boldon fgyellow $0 normal; next }

# Merge warning
#
/^(cvs|rcsmerge)[ 0-9A-z]*: (warning|conflicts):?/ {
    print boldon fgyellow $0 normal; next
}

# CVS informational messages
#
{ print boldon fgblue $0 normal }
