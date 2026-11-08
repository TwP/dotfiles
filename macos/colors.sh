# Defines several methods for outputting colorized text to the termianl.
# -----------------------------------------------------------------------------

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'

msg() {
  echo -e "${CYAN}${1}${RESET}"
  return
}

red() {
  echo -e "${RED}${1}${RESET}"
  return
}

green() {
  echo -e "${GREEN}${1}${RESET}"
  return
}

yellow() {
  echo -e "${YELLOW}${1}${RESET}"
  return
}

blue() {
  echo -e "${BLUE}${1}${RESET}"
  return
}

magenta() {
  echo -e "${MAGENTA}${1}${RESET}"
  return
}

cyan() {
  echo -e "${CYAN}${1}${RESET}"
  return
}

white() {
  echo -e "${WHITE}${1}${RESET}"
  return
}

# vim:ft=sh
