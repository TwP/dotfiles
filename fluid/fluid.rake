require 'fileutils'

namespace :fluid do
  desc "Install Fluid apps and their stored preferences"
  task :install do
    FluidApp.apps.each do |name|
      app = FluidApp.new(name)

      puts "Installing: #{app.app_name.inspect}"
      app.install_app
      app.install_prefs
    end
  end

  desc "Backup Fluid apps to iCloud Drive"
  task :backup => :setup do
    FluidApp.apps.each do |name|
      app = FluidApp.new(name)

      puts "Backing up: #{app.app_name.inspect}"
      app.backup!
    end
  end

  desc "Delete all Fluid apps from iCloud Drive"
  task :clobber do
    FluidApp.clobber!
  end

  desc "List the Fluid apps to back up"
  task :apps do
    puts FluidApp.apps
  end

  task :setup do
    FileUtils.mkdir_p(FluidApp.apps_path)
    FileUtils.mkdir_p(FluidApp.prefs_path)
  end
end

class FluidApp
  # Path to the documents in iCloud Drive
  LIBRARY      = File.join(ENV["HOME"], "Library")
  PREFERENCES  = File.join(LIBRARY, "Preferences").freeze
  FLUID_DIR    = File.join(BOOTSTRAP_DRIVE, "Fluid").freeze
  FLUID_PREFIX = "com.fluidapp.FluidApp2".freeze
  APPLICATIONS = "/Applications".freeze

  def self.apps
    plist_glob = File.join(PREFERENCES, "#{FLUID_PREFIX}.*.plist")
    apps = Dir.glob(plist_glob).map {|plist| plist.match(%r/#{FLUID_PREFIX}\.([\w\s]+)\.plist/)[1]}
    apps.sort
  end

  def self.apps_path(*args)
    if args.empty?
      File.join(FLUID_DIR, "apps")
    else
      File.join(FLUID_DIR, "apps", *args)
    end
  end

  def self.prefs_path(*args)
    if args.empty?
      File.join(FLUID_DIR, "prefs")
    else
      File.join(FLUID_DIR, "prefs", *args)
    end
  end

  def initialize(name)
    @name = name

    @app_name = "#{name}.app".freeze
    @app_bak  = FluidApp.apps_path(app_name).freeze
    @app_dest = File.join(APPLICATIONS, app_name).freeze

    @prefs_name = "com.fluidapp.FluidApp2.#{name}.plist".freeze
    @prefs_bak  = FluidApp.prefs_path(prefs_name).freeze
    @prefs_dest = File.join(PREFERENCES, prefs_name).freeze
  end

  attr_reader :name
  attr_reader :app_name,   :app_bak,   :app_dest
  attr_reader :prefs_name, :prefs_bak, :prefs_dest

  # Only install the application if the destination file does not exist.
  #
  # Returns `true` if the app was installed; `false` otherwise.
  def install_app
    return false if File.exists?(app_dest)
    install_app!
  end

  # Install the application regardless of the existence of the destination file.
  # The srouce file must exist, however.
  #
  # Returns `true` if the app was installed; `false` otherwise.
  def install_app!
    return false unless File.exists?(app_bak)

    puts "  application: #{app_dest.inspect}"
    FileUtils.cp_r(app_bak, app_dest)
    true
  end

  # Only install the application preferences if the destination file does not exist.
  #
  # Returns `true` if the app was installed; `false` otherwise.
  def install_prefs
    return false if File.exists?(prefs_dest)
    install_prefs!
  end

  # Install the application preferences regardless of the existence of the
  # destination file. The srouce file must exist, however.
  #
  # Returns `true` if the prefs were installed; `false` otherwise.
  def install_prefs!
    return false unless File.exists?(prefs_bak)

    puts "  preferences: #{prefs_dest.inspect}"
    FileUtils.cp(prefs_bak, prefs_dest)
    true
  end

  # Backup this Fluid app to iCloud Drive.
  #
  # Returns `true` if the files were copied; `false` otherwise
  def backup!
    return false unless File.exists?(app_dest) && File.exists?(prefs_dest)

    puts "  application: #{app_dest.inspect}"
    FileUtils.rm_r(app_bak, secure: true) if File.exists?(app_bak)
    FileUtils.cp_r(app_dest, app_bak)

    puts "  preferences: #{prefs_dest.inspect}"
    FileUtils.rm_r(prefs_bak, secure: true) if File.exists?(prefs_bak)
    FileUtils.cp(prefs_dest, prefs_bak)

    true
  end

  # Delete all backup files in iCloud Drive and remove the Fuild app
  # directories. All traces of the Fuild apps will be wiped clean from iCloud
  # Drive. Local Fluid apps are not affected.
  def self.clobber!
    if File.exists?(FluidApp.apps_path)
      list = Dir.glob(FluidApp.apps_path("*"))
      FileUtils.rm_r(list, secure: true)
      FileUtils.rm_r(FluidApp.apps_path, secure: true)
    end

    if File.exists?(FluidApp.prefs_path)
      list = Dir.glob(FluidApp.prefs_path("*"))
      FileUtils.rm(list, force: true)
      FileUtils.rm_r(FluidApp.prefs_path, secure: true)
    end

    if File.exists?(FLUID_DIR)
      FileUtils.rm_r(FLUID_DIR, secure: true)
    end

    nil
  end
end
