require 'fileutils'

namespace :launchbar do
  desc "Install custom LaunchBar actions"
  task :install => :build do
    dest = File.expand_path("~/Library/Application Support/LaunchBar/Actions")
    abort "LaunchBar does not appear to be installed" unless File.exists?(dest)

    path = File.expand_path("..", __FILE__)
    actions = Dir.glob(File.join(path, "pkg", "*.lbaction"))

    actions.each do |action|
      destname = File.join(dest, File.basename(action))
      FileUtils.rm_r(destname) if File.exists?(destname)
      FileUtils.cp_r(action, dest)
    end
  end

  task :build => :pkg do
    path  = File.expand_path("../pkg", __FILE__)
    files = Dir.glob(File.join(path, "**/*.applescript"))

    files.each do |filename|
      script = File.join(File.dirname(filename), File.basename(filename, ".applescript") + ".scpt")

      `osacompile -o '#{script}' '#{filename}'`
      FileUtils.rm(filename)
    end
  end

  task :pkg do
    path = File.expand_path("..", __FILE__)
    pkg  = File.join(path, "pkg")
    actions = Dir.glob(File.join(path, "*.lbaction"))

    FileUtils.rm_r(pkg) if File.exists? pkg
    FileUtils.mkdir(pkg)
    actions.each { |action| FileUtils.cp_r(action, pkg) }
  end

  desc "Cleanup build artifacts"
  task :cleanup do
    path = File.expand_path("..", __FILE__)
    pkg  = File.join(path, "pkg")

    FileUtils.rm_r(pkg) if File.exists?(pkg)
  end
end
