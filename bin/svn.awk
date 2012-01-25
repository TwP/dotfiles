# svn.awk
#
# This is an nawk script used to colorize the output from Subversion.   Simply
# pipe the output from cvs operations into the nawk (or gawk) program with this
# file as the awk script.
#
# Examples:
#    svn st -u 2>&1 | nawk -f svn.awk
#
# Functions:
#    check () { svn st $* 2>&1 | nawk -f svn.awk; }
#    svnup () { svn up $* 2>&1 | nawk -f svn.awk; }
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

# Ignored or Unknown
#
/^[I\?] / { print boldon fgwhite $0 normal; next }


# Needs Update or Merged
#
/^       \*/ { print boldon fggreen $0 normal; next }
/^G[ G]/     { print        fggreen $0 normal; next }
/^U[ U]/     { print boldon fggreen $0 normal; next }
/^ U/        { print        fggreen $0 normal; next }


# Modified
#
/^M[ M].....\*/ { print boldon bgyellow fgmagenta $0 normal; next }
/^ M.....\*/    { print        bgyellow fgmagenta $0 normal; next }
/^M[ M]/ { print boldon fgmagenta $0 normal; next }
/^ M/    { print        fgmagenta $0 normal; next }


# Added
#
/^A[ A]/ { print boldon fgcyan $0 normal; next }
/^ A/    { print        fgcyan $0 normal; next }

# Deleted or Replaced
#
/^D[ D].....\*/ { print boldon bgyellow fgred $0 normal; next }
/^R......\*/    { print        bgyellow fgred $0 normal; next }
/^D[ D]/ { print boldon fgred $0 normal; next }
/^ D/    { print        fgred $0 normal; next }
/^R/     { print        fgred $0 normal; next }


# Conflict
#
/^C[ C]/ { print boldon fgwhite bgred $0 normal; next }
/^ C/    { print        fgwhite bgred $0 normal; next }


# Obstructed or Missing
#
/^~/ {print boldon fgwhite bgyellow $0 normal; next }
/^!/ {print boldon fgyellow         $0 normal; next }


# Subversion informational messages
#
{ print normal $0 }
