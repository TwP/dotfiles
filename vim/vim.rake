namespace :vim do
  task :install do
    cfg_path = File.join("#{ENV["HOME"]}", ".config/")
    source = File.join(File.expand_path("..", __FILE__), "nvim")
    target = File.join(cfg_path, "nvim")

    FileUtils.mkdir_p(cfg_path)

    if File.exist?(target) && File.symlink?(target) && source == File.readlink(target)
      puts "Skipping nvim - already set correctly"
    else
      if File.exist?(target) || File.symlink?(target)
        FileUtils.rm_rf(target)
      end
      puts "Linking nvim"
      `ln -s "$PWD/#{source}" "#{target}"`
    end
  end
end
