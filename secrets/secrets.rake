require 'fileutils'

DMG_FILE    = File.join(ENV['ICLOUD_DRIVE'], "secrets.dmg").freeze
VOLUME_NAME = "Secrets".freeze
VOLUME      = File.join("", "Volumes", VOLUME_NAME).freeze

# Describe the secrets to store in the iCloud Drive encrypted disk image
# The key is the folder in the encrypted disk image where the secrets will be
# store. The sub-hash describes the `:source` directory for the file, and the
# `:glob` patterns used to match the files that will be copied.
FILES = {
  "ssh" => {
    source: "~/.ssh",
    glob:   %w[authorized_keys config* *rsa*]
  },
  "gh_ssh" => {
    source: "~/GitHub/.ssh",
    glob:   "*"
  },
  "secret" => {
    source: "~/.dotfiles/secret",
    glob:   "**/*"
  }
}

namespace :secrets do
  desc "Install secrets from iCloud Drive"
  task :install => %i[setup install_files teardown]

  desc "Backup secrets to iCloud Drive"
  task :backup => %i[setup backup_files teardown]

  # Performs the actual work of install files from iCloud Drive
  # into their appropriate locations
  task :install_files do
    puts "installing up files ..."
  end

  # Performs the actual work of backing up files to iCloud Drive
  task :backup_files do
    pwd = Dir.pwd
    begin
      FILES.each do |backup, h|
        source = h[:source]
        globs  = h[:glob]

        # skip these files if the source directory does not exist
        src_dir = File.expand_path(source)
        next unless File.exists?(src_dir) && File.directory?(src_dir)

        Dir.chdir(src_dir)
        dest_dir = File.join(VOLUME, backup)

        Array(globs).each do |glob|
          Dir.glob(glob).each do |file|
            next if File.directory?(file)

            d      = File.join(dest_dir, file)
            d_name = File.join(backup, file)

            s      = File.join(src_dir,  file)
            s_name = File.join(source, file)

            if !File.exists?(d) || (File.mtime(s) > File.mtime(d))
              puts "Copying:  #{s_name.inspect} --> #{d_name.inspect}"
              FileUtils.mkdir_p(File.dirname(d))
              FileUtils.cp(s, d, preserve: true)
            else
              puts "Skipping: #{s_name.inspect} --> #{d_name.inspect}"
            end
          end
        end
      end
    ensure
      Dir.chdir(pwd)
    end
  end

  task :setup => %i[create_dmg mount_volume]

  task :teardown => :detach_volume

  task :create_dmg do
    unless File.exists? DMG_FILE
      cmd = %Q{hdiutil create -type UDIF -encryption AES-256 -size 10m -fs "Journaled HFS+" -volname "#{VOLUME_NAME}" -attach "#{DMG_FILE}"}
      puts "Creating an ecrypted disk image for storing secrets ..."
      puts cmd
      Kernel.system cmd
    end
  end

  task :mount_volume do
    unless File.exists? VOLUME
      cmd = %Q{hdiutil attach "#{DMG_FILE}"}
      puts "Mounting encrypted secrets disk image ..."
      puts cmd
      Kernel.system cmd
    end
  end

  task :detach_volume do
    if File.exists? VOLUME
      cmd = %Q{hdiutil detach "#{VOLUME}"}
      puts "Detaching encrypted secrets disk image ..."
      puts cmd
      Kernel.system cmd
    end
  end
end
