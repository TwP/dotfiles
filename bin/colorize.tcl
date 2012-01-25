#!/bin/sh
# $Id: colorize.tcl,v 1.3 2003/12/22 23:21:32 tpease Exp $
# Run this file using tclsh \
exec /usr/local/tcl/bin/tclsh8.4 "$0" "$@"

# Usage:
#
#   colorize.tcl type
#
# This script reads standard input line-by-line and colorizes the lines
# according to the specified input type.  Each line is then written to standard
# out.
# 
# The colors are defined in the .colorizerc file located in the user's home
# directory.  This file will be created the first time the colorize.tcl script
# is executed.  Subsequent executions of the script will read the .colorizerc
# file to determine which colors to use for output.
# 
# Allowed types:
#   make - input contains gnu make lines
#   cvs  - input contains cvs lines (only "cvs update" lines can be colorized)
#   diff - input contains diff lines (using the -c option only)
#
# Examples:
#
#   For gnu make
#   > make 2>&1 | colorize.tcl make
#
#   For cvs
#   > cvs -n up 2>&1 | colorize.tcl cvs
#   > cvs up -Pd 2>&1 | colorize.tcl cvs
#
#   For diff
#   > diff -c temp1.txt temp2.txt 2>&1 | colorize.tcl diff
#   > cvs diff -c -r 1.2 -r 1.3 somefile 2>&1 | colorize.tcl diff
#
# Bash functions using colorize.tcl:
#
#   cmake () { make $* 2>&1 | colorize.tcl make; }
#
#   check   () { cvs -n up $* 2>&1 | colorize.tcl cvs; }
#   cvsup   () { cvs up -Pd $* 2>&1 | colorize.tcl cvs; }
#   cvsdiff () { cvs diff -c $* 2>&1 | colorize.tcl diff; }
#
#   cdiff   () { diff -c $* 2>&1 | colorize.tcl diff; }
#


# The list of known colors and fonts
# NOTE: The escape character (0x1B) is the first character in each of the
#       following color strings.  Normally you can use "\033" (the escaped
#       octal value), but this does not work on Cygwin.  The literal escape
#       character is used here, and so it might look a little funky.
#
set normal       "\[0m"
set boldon       "\[1m"
set italicson    "\[3m"
set underlineon  "\[4m"
set inverseon    "\[7m"
set strikethon   "\[9m"
set boldoff      "\[22m"
set italicsoff   "\[23m"
set underlineoff "\[24m"
set inverseoff   "\[27m"
set strikethoff  "\[29m"
set fgblack      "\[30m"
set fgred        "\[31m"
set fggreen      "\[32m"
set fgyellow     "\[33m"
set fgblue       "\[34m"
set fgmagenta    "\[35m"
set fgcyan       "\[36m"
set fgwhite      "\[37m"
set fgdefault    "\[39m"
set bgblack      "\[40m"
set bgred        "\[41m"
set bggreen      "\[42m"
set bgyellow     "\[43m"
set bgblue       "\[44m"
set bgmagenta    "\[45m"
set bgcyan       "\[46m"
set bgwhite      "\[47m"
set bgdefault    "\[49m"

# Load user specific defaults (if the file exists)
set rc [file join $env(HOME) .colorizerc]

if {![file exists $rc]} {
   set fd [open $rc w]

   puts $fd "# Defaults used by the colorize.tcl script"
   puts $fd "# Refer to the colorize.tcl script for the list of defined colors"
   puts $fd ""
   puts $fd "# cvs update color scheme"
   puts $fd "set cvs_warning  \"\${fgyellow}\${boldon}\""
   puts $fd "set cvs_info     \"\${fgblue}\${boldon}\""
   puts $fd "set cvs_unknown  \"\${fgwhite}\${boldon}\""
   puts $fd "set cvs_modified \"\${fgmagenta}\${boldon}\""
   puts $fd "set cvs_added    \"\${fgcyan}\${boldon}\""
   puts $fd "set cvs_updated  \"\${fggreen}\${boldon}\""
   puts $fd "set cvs_remove   \"\${fgred}\${boldon}\""
   puts $fd "set cvs_tag      \"\${fgred}\""
   puts $fd "set cvs_conflict \"\${bgred}\${fgwhite}\${boldon}\""
   puts $fd ""
   puts $fd "# diff color scheme"
   puts $fd "set diff_info    \"\${fgblue}\${boldon}\""
   puts $fd "set diff_added   \"\${fggreen}\${boldon}\""
   puts $fd "set diff_changed \"\${fgyellow}\${boldon}\""
   puts $fd "set diff_removed \"\${fgred}\${boldon}\""
   puts $fd ""
   puts $fd "# make color scheme"
   puts $fd "set make_info       \"\${fgblue}\${boldon}\""
   puts $fd "set make_error      \"\${bgred}\${fgwhite}\${boldon}\""
   puts $fd "set make_warning    \"\${fgred}\${boldon}\""
   puts $fd "set make_alert      \"\${fgyellow}\${boldon}\""
   puts $fd "set make_comment    \"\${fgcyan}\${boldon}\""
   puts $fd "set make_sourcefile \"\${fgmagenta}\${boldon}\""
   puts $fd ""
   puts $fd "# EOF"
   puts $fd ""

   close $fd
}

source $rc

# Figure out the type of input to colorize
#
set type ""
if {$argc > 0} { set type [lindex [split $argv { }] 0] }

# Start colorizing
#
switch $type {
   cvs {
      while {![eof stdin]} {
	 set s [gets stdin]

         if {[regexp {^(cvs|rcsmerge)[ 0-9A-z]*: (warning|conflicts):?} $s] ||
	     [regexp {^Merging} $s]} {
            puts "${cvs_warning}${s}${normal}"
         } elseif [regexp {^\? } $s] {
            puts "${cvs_unknown}${s}${normal}"
	 } elseif [regexp {^M } $s] {
            puts "${cvs_modified}${s}${normal}"
	 } elseif [regexp {^A } $s] {
	    puts "${cvs_added}${s}${normal}"
         } elseif [regexp {^[UP] } $s] {
            puts "${cvs_updated}${s}${normal}"
         } elseif [regexp {^C } $s] {
	    puts "${cvs_conflict}${s}${normal}"
         } elseif [regexp {^T } $s] {
	    puts "${cvs_tag}${s}${normal}"
         } elseif [regexp {^R } $s] {
	    puts "${cvs_remove}${s}${normal}"
         } else {
            puts "${cvs_info}${s}${normal}"
         }
      }
   }

   diff {
      while {![eof stdin]} {
	 set s [gets stdin]

         if [regexp {^\+ } $s] {
            puts "${diff_added}${s}${normal}"
         } elseif [regexp {^! } $s] {
            puts "${diff_changed}${s}${normal}"
         } elseif [regexp {^- } $s] {
            puts "${diff_removed}${s}${normal}"
         } elseif [regexp {^[^ \t]} $s] {
            puts "${diff_info}${s}${normal}"
         } else {
            puts ${s}
         }
      }
   }

   make {
      set ofInterest {}

      while {![eof stdin]} {
         set s [gets stdin]

         # Errors reported by the make system
         if [regexp {^make(\[[0-9]+\])?: \*\*\*} $s] {
            puts "${make_error}${s}${normal}"

         # Normal make info lines
         } elseif [regexp {^make} $s] {
            puts "${make_info}${s}${normal}"

         # Warnings generated by the compiler (file must end in .h .hpp .c .cpp)
         } elseif [regexp {^[0-9A-Za-z_/]+\.(hpp|h|cpp|c):([0-9]+:)* warning} $s] {
            puts "${make_warning}${s}${normal}"
            lappend ofInterest "${make_warning}${s}${normal}"

         # Compiler generated alerts (file must end in .h .hpp .c .cpp)
         } elseif {[regexp {^[0-9A-Za-z_/]+\.(hpp|h|cpp|c):} $s] ||
                   [regexp {^In file included from} $s]          ||
       	           [regexp {^                 from} $s]} {
            puts "${make_alert}${s}${normal}"
            lappend ofInterest "${make_alert}${s}${normal}"

         # Comments generated by the make system
         } elseif [regexp {^(==>>|\*\*\*\*)} $s] {
            puts "${make_comment}${s}${normal}"

         # Everything else is white text on a black background
	 # -- except for compiler lines; we are grabbing the filename from
	 # -- compiler lines
         } else {
	    set rgxp {((?:[^ ]*[ ]+)+)([0-9A-z]+\.(?:hpp|h|cpp|c))(.*)}
	    if [regexp $rgxp $s line pre filename post] {
	       puts "${pre}${make_sourcefile}${filename}${normal}${post}"
	    } else {
               puts ${s}
	    }
         }
      }

      if {[llength $ofInterest] > 0} {
         puts "${make_info}===== Build Summary =====${normal}"
         foreach s $ofInterest { puts $s }
      }
   }

   default {
      while ![eof stdin] { puts [gets stdin] }
   }
}

# EOF
