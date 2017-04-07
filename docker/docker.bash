# ==== Docker Setup ====
# Some fucntions useful for working with Docker

alias dscr="screen ${HOME}/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty"
alias drm='docker rm $(docker ps -aqf status=exited)'
