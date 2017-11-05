require 'fileutils'

namespace :launchbar do
  desc "Install custom LaunchBar actions and snippets"
  task :install => %i[backup build] do
    path = File.expand_path("..", __FILE__)
    dest = File.expand_path("~/Library/Application Support/LaunchBar")
    abort "LaunchBar does not appear to be installed" unless File.exists?(dest)

    actions = File.join(dest, "Actions")
    FileUtils.symlink(File.join(path, ".Actions.pkg"), actions) unless File.symlink?(actions)

    snippets = File.join(dest, "Snippets")
    FileUtils.symlink(File.join(path, "Snippets"), snippets) unless File.symlink?(snippets)
  end

  task :backup do
    dest = File.expand_path("~/Library/Application Support/LaunchBar")
    %w[Actions Snippets].each do |dir|
      dest_dir = File.join(dest, dir)
      FileUtils.mv(dest_dir, "#{dest_dir}.backup", force: true) if File.directory?(dest_dir) && !File.symlink?(dest_dir)
    end
  end

  task :build => :pkg do
    path  = File.expand_path("../.Actions.pkg", __FILE__)
    files = Dir.glob(File.join(path, "**/*.applescript"))

    files.each do |filename|
      script = File.join(File.dirname(filename), File.basename(filename, ".applescript") + ".scpt")

      `osacompile -o '#{script}' '#{filename}'`
      FileUtils.rm(filename)
    end
  end

  task :pkg do
    path = File.expand_path("../Actions", __FILE__)
    pkg  = File.expand_path("../.Actions.pkg", __FILE__)
    actions = Dir.glob(File.join(path, "*.lbaction"))

    FileUtils.rm_r(pkg) if File.exists? pkg
    FileUtils.mkdir(pkg)
    actions.each { |action| FileUtils.cp_r(action, pkg) }
  end

  desc "Cleanup build artifacts"
  task :cleanup do
    path = File.expand_path("..", __FILE__)
    pkg  = File.join(path, ".Actions.pkg")

    FileUtils.rm_r(pkg) if File.exists?(pkg)
  end
end
