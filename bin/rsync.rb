#!/usr/bin/env ruby

class Rsync

  def initialize
    @flags = %w[-v -rulptzCF]
    @dir = "~" + Dir.pwd.sub(ENV['HOME'], '') + '/'
  end

  def push( remote, *args )
    args.concat @flags
    args << @dir
    args << "#{remote}:#@dir"
    Kernel.exec "/opt/local/bin/rsync #{args.join(' ')}"
  end

  def pull( remote, *args )
    args.concat @flags
    args << "#{remote}:#@dir"
    args << @dir
    Kernel.exec "/opt/local/bin/rsync #{args.join(' ')}"
  end

end  # class Rsync

if __FILE__ == $0
  direction = ARGV.shift
  remote = ARGV.pop
  Rsync.new.__send__(direction.to_sym, remote, *ARGV)
end

# EOF
