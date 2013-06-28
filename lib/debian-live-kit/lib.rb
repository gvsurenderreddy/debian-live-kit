def init_base_setup
  echo "Configure the debian setup script"
  File.open("modit/setup.sh","w") do |f|
    f.puts BASE_SETUP 
    EXTRA_PKGS.each do |pkg|
      f.puts "echo -e \"\nlive\n\" | apt-get --yes --force-yes install #{pkg.join}"
    end
    f.puts "apt-get clean"
  end
end  

def failed()
  puts "Something went wrong. Below is `tail` of #{Dir.getwd}/.log.txt"  
  puts `tail .log.txt`
  puts "Failed!"
  exit(1)
end

def create_paths()
  mkdir "modules"
  mkdir_m "extract"
  mkdir_t "tools"
  x "mkdir tools/opt"
  mkdir_t "firmware"
  x "mkdir firmware/lib/"
  mkdir_t "pen-chroot"
  x "mkdir pen-chroot/bin"
  mkdir "modit"
  mkdir_m "deb-base"
  mkdir "target"
  mkdir_m "porteus-source"
end

def clean bool=false
  echo "Perform soft clean..."
  MOUNTS.each do |m|
    x "umount -l #{m}"
  end
  
  TEMPS.each do |t|
    x "rm -rf #{t}"
  end
  
  if bool
    echo "Perform FULL CLEAN!!"
    DIRS.each do |d|
      "rm -rf #{d}"
    end
  end
end

def strip_porteus(target)
  echo "Stripping porteus..."
  unless x("rm #{target}/*/base/*x*.xzm") &&
         x("rm #{target}/*/base/*core*.xzm") &&
         x("rm #{target}/*/base/*devel*.xzm")  
    failed()
  end
end


# initailizes the debian base
# debootstrap's a minimal debian
def init_base
  echo "Prepare the debian base"
 # x "rm -rf modit/*"
 # unless x("debootstrap --arch=i386 #{RELEASE} modit") &&
         init_base_setup() &&
         x("chroot modit /bin/bash /setup.sh")
  #  failed()
  #end
  
  cache = Dir.glob("modit/var/cache/apt/a*/*.deb")
  
  failed() unless File.exist?("modit/home/live")
rescue
  failed()
end

def inflate_porteus(from,to)
  echo "Mount the Porteus medium..."
  failed() unless mount(from, to)
end

def init_debian(from,where)
  echo "Prepare the target..."
  failed() unless x("cp -rf #{from}/* #{where}/")
end

def extract_porteus(path)
  echo "Extracting porteus"
  echo "Extracting needed files from porteus"
  
  echo "Extracting firmware"  
  failed() unless mount("#{path}/*/base/*core*.xzm", "extract")
  
  unless x("cp -rf extract/lib/modprobe.d firmware/lib/") &&
         x("cp -rf extract/lib/firmware firmware/lib/")
    failed()
  end
  
  echo "extracting tools"  
  failed() unless x("cp -rf extract/opt/porteus* tools/opt/")
  
  echo "extracting chroot"
  failed() unless x("cp extract/bin/chroot pen-chroot/bin/")
  
  
  unless dir2xzm("firmware",a=MODULES[:firmware]) &&
         dir2xzm("pen-chroot",b=MODULES[:chroot]) &&
         dir2xzm("tools",c=MODULES[:tools])
    failed()
  end
  
  [a,b,c].each do |m|
    x "mv #{m} modules/"
  end
end

def mount_pen()
  x "mkdir pen"
  echo "mount device..."
  x "mount #{OPTS[:device]} pen"  
end

def modify(from)
  x "chroot #{from}"
end

def unpack(from,to)
  mp = "deb-base"
  mkdir_m mp
  
  if x "mount #{from}/*/modules/#{MODULES[:base]} #{mp}"
    x "rm -rf #{to}/*"
    x "cp -rf deb-base/* #{to}/"
  end
  
  x "umount -l #{mp}"
end

def mkdeb(target)
  echo "Making target a bootable linux-live-kit debian..."
  Dir.glob("modules/*").each do |m|
    failed() unless x("cp #{m} #{target}/*/modules/")
  end
  
  img = OPTIONS[:splash] || SPLASH_IMAGE
  
  echo "WARNING: splash image not copied" unless x("cp #{img} #{target}/boot/syslinux/porteus.jpg")
  
  echo "make always fresh"
  buff = SYSLNX_CFG
  File.open("#{target}/boot/syslinux/porteus.cfg","w") do |f| f.puts buff end
end

def pack(target)
  echo "Packing debian base..."
  
  xzm = xzm=MODULES[:base]
  
  unless dir2xzm("modit", xzm) &&
         x("mv #{xzm} #{target}/*/modules/")
    failed()
  end
end

def mkpen(device,from)
  echo "Installing to device..."
  
  x "mkdir pen"
  
  unless x("mkfs.ext3 #{device}") &&
         mount(device, "pen")
    failed()
  end
  
  failed() unless x("cp -rf #{from}/* pen/")
  
  od = Dir.getwd
  Dir.chdir "pen/boot"
  
  x("chmod 755 ./*.com")
  
  unless system("./*.com")
    failed()
  end
  
  x("umount -l pen")

  
  
  x "rm -rf pen"
  
  Dir.chdir od
  
  echo "Completed. You may now boot the device."
end
