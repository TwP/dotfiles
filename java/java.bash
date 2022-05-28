# ==== Java Setup ====

export JAVA_HOME=`/usr/libexec/java_home`
# export GRADLE_HOME="/usr/local/share/gradle"

# configure asdf for Java https://github.com/halcyon/asdf-java#java_home
function jhome {
  if [ -f ~/.asdf/plugins/java/set-java-home.bash ]; then
    source ~/.asdf/plugins/java/set-java-home.bash
  fi
}
jhome
