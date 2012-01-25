# cdiff.awk
#
# This is an nawk script used to colorize the output from a contextual diff.
# Simply pipe the output from the contextual diff into the nawk (or gawk)
# program with this file as the awk script.
#
# Examples:
#    diff -c file1 file2 2>&1 | nawk -f cdiff.awk
#
# Functions:
#    cdiff   () {     diff -c $* 2>&1 | nawk -f cdiff.awk; }
#    cvsdiff () { cvs diff -c $* 2>&1 | nawk -f cdiff.awk; }
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

# Added lines will be colored green
#
/^\+ / { print boldon fggreen $0 normal; next }

# Changed lines will be colored yellow
#
/^! / { print boldon fgyellow $0 normal; next }

# Removed lines will be colored red
#
/^- / { print boldon fgred $0 normal; next }

# Informational lines will be colored blue
#
/^[^ \t]/ { print boldon fgblue $0 normal; next }

# Print regular lines here
#
{ print $0 }
