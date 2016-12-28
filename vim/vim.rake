namespace :vim do
  desc "Install the Vundle plug-in manager for Vim"
  task :install do
    path = File.expand_path("..", __FILE__)
    vundle_path = File.join(path, "vim.symlink", "bundle", "vundle")

    cmd = if File.exists?(vundle_path)
      "cd '#{vundle_path}' && git pull"
    else
      "git clone https://github.com/VundleVim/Vundle.vim.git '#{vundle_path}'"
    end

    puts "Executing: `#{cmd}`"
    puts `#{cmd}`
  end
end
