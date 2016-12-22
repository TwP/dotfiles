require 'fileutils'

DMG_FILE    = File.join(ENV['ICLOUD_DRIVE'], "secrets.dmg").freeze
VOLUME_NAME = "Secrets".freeze
VOLUME      = File.join("", "Volumes", VOLUME_NAME).freeze

namespace :secrets do
  desc "Install secrets from iCloud Drive"
  task :install => %i[setup install_files teardown]

  desc "Backup secrets to iCloud Drive"
  task :backup => %i[setup backup_files teardown]

  # Performs the actual work of install files from iCloud Drive
  # into their appropriate locations
  task :install_files do
    puts "installing files ..."
  end

  # Performs the actual work of backing up files to iCloud Drive
  task :backup_files do
    puts "backing up files ..."
  end

  task :setup => %i[create_dmg mount_volume]

  task :teardown => :detach_volume

  task :create_dmg do
    unless File.exists? DMG_FILE
      cmd = %Q{hdiutil create -type UDIF -encryption AES-256 -size 10m -fs "Journaled HFS+" -volname "#{VOLUME_NAME}" "#{DMG_FILE}"}
      puts "Creating an ecrypted disk image for storing secrets ..."
      puts cmd
      `#{cmd}`
    end
  end

  task :mount_volume do
    unless File.exists? VOLUME
      cmd = %Q{hdiutil attach "#{DMG_FILE}"}
      puts "Mounting encrypted secrets disk image ..."
      puts cmd
      `#{cmd}`
    end
  end

  task :detach_volume do
    if File.exists? VOLUME
      cmd = %Q{hdiutil detach "#{VOLUME}"}
      puts "Detaching encrypted secrets disk image ..."
      puts cmd
      `#{cmd}`
    end
  end
end
