namespace :starship do
  task :install do
    cfg = "starship.toml"
    src = File.join(File.expand_path("..", __FILE__), cfg)
    dst_path = File.join("#{ENV["HOME"]}", ".config/")
    target = File.join(dst_path, cfg)

    FileUtils.mkdir_p(dst_path)

    if File.exist?(target) && File.symlink?(target) && src == File.readlink(target)
      puts "Skipping #{cfg} - already set correctly"
    else
      if File.exist?(target) || File.symlink?(target)
        FileUtils.rm_rf(target)
      end
      puts "Linking #{cfg}"
      `ln -s "#{src}" "#{target}"`
    end
  end
end
