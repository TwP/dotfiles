# ==== Java Setup ====

JAVA_HOME=$(/usr/libexec/java_home 2> /dev/null)
export JAVA_HOME

# configure asdf for Java https://github.com/halcyon/asdf-java#java_home
if [ -f ~/.asdf/plugins/java/set-java-home.bash ]; then
  source ~/.asdf/plugins/java/set-java-home.bash
fi
