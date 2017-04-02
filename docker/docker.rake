DOCKER_RESOURCES = "/Applications/Docker.app/Contents/Resources/etc"
COMPLETION_DIR   = "/usr/local/etc/bash_completion.d"

namespace :docker do
  desc "Install the Docker bash completion symlinks"
  task :install do

    %w[
      docker.bash-completion
      docker-machine.bash-completion
      docker-compose.bash-completion

    ].each do |file|
      source = "#{DOCKER_RESOURCES}/#{file}"
      target = "#{COMPLETION_DIR}/#{File.basename(file, ".*")}"
      next if File.exists? target

      cmd = "ln -s #{source} #{target}"
      puts "Executing: `#{cmd}`"
      `#{cmd}`
    end
  end
end
