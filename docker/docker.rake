namespace :docker do
  desc "Install the Docker bash completion symlinks"
  task :install do

    %w[
      docker.bash-completion
      docker-machine.bash-completion
      docker-compose.bash-completion

    ].each do |file|
      source = "/Applications/Docker.app/Contents/Resources/etc/#{file}"
      target = "#{ENV["HOMEBREW_ROOT"]}/etc/bash_completion.d/#{File.basename(file, ".*")}"
      next if File.exists? target

      cmd = "ln -s #{source} #{target}"
      puts "Executing: `#{cmd}`"
      `#{cmd}`
    end
  end
end
