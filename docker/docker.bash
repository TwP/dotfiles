# ==== Docker Setup ====
# Some fucntions useful for working with Docker

alias dscr="screen ${HOME}/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty"
alias dpsa="docker ps -a"
alias drm='docker rm $(docker ps -aqf status=exited)'
alias dq="osascript -e 'quit app \"docker\"'"
alias dv="docker volume ls"
alias dn="docker network ls"
