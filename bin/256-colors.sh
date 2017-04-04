#!/usr/bin/env bash

# Liberally stoeln from http://misc.flogisoft.com/bash/tip_colors_and_formatting

# for fgbg in 38 48 ; do #Foreground/Background

for fgbg in 48 ; do # Background only - foreground colors were not helpful to me
  for color in {0..15} ; do
    #Display the color
    echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
    #Display 8 colors per line
    if [ $((($color + 1) % 8)) == 0 ] ; then
      echo #New line
    fi
  done
  for color in {0..239} ; do #Colors
    #Display the color
    adj_color=$((color+16))
    echo -en "\e[${fgbg};5;${adj_color}m ${adj_color}\t\e[0m"
    #Display 6 colors per line
    if [ $((($color + 1) % 6)) == 0 ] ; then
      echo #New line
    fi
  done
  echo #New line
done

exit 0
