def echo msg
  puts "# \e[35m#{msg}\e[0m"
  `echo "\e[35m#{msg}\e[0m" >> .log.txt`  
end

def x cmd
  x! cmd
end

def x! cmd
  puts "\e[34m#{cmd}\e[0m"
  `echo "\e[34m#{cmd}\e[0m" >> .log.txt`
  system cmd+" >> .log.txt 2>&1"
end

def init()
  echo "initialize structure..."
  work = "#{ENV['HOME']}/.work"
  x "mkdir #{work}"
  
  Dir.chdir(work)
  `rm .log.txt`
  create_paths()  
end


def mount what,where
  x "umount -l #{where}"
  x "mount #{what} #{where}"
end

def mkdir path
  DIRS << path
  x "mkdir #{path}"
end

def mkdir_t path
  TEMPS << path
  x "mkdir #{path}"
end

def mkdir_m path
  MOUNTS << path
  x "mkdir #{path}"
end

def dir2xzm from,to
  echo "Making XZM module of #{from}, to, #{to}"
  x "rm -f #{to}" # overwrite, never append to existing file
  if !x("mksquashfs #{from} #{to} -b 256K -comp xz -Xbcj x86") #  $3 $4 $5 $6 $7 $8 $9
    return false
  end
  x "chmod a-wx #{to}" # remove execute and write attrib
  x "chmod a+r #{to}" # add read for everyone
end