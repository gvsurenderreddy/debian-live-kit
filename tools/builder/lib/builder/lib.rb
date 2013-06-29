def x! cmd
  puts cmd
  system cmd
end

def x(cmd,chroot)
  x! "chroot #{chroot} #{cmd}"
end

def init(from,type)
  x!("mkdir #{WORK}")  
  Dir.chdir(WORK)
  get_packages(type,from)
  x! "mkdir -p #{type}/base"
  x! "cp -rf #{from}/* #{type}/base/"
end  
  
def do_diff from,to
  buff =  `diff -qr #{from} #{to}`
  additions = []
  buff.scan(/^Only in (.*?)\: (.*?)$/).each do |a|
    path,name = *a
    if path =~ Regexp.new(Regexp.escape(to))
      additions << File.join(path,name)
    end
  end

  modified = []
  
  buff.scan(/^Files (.*?) and (.*?) differ$/).each do |a|
    modified << $2
  end  

  all = additions.push(*modified).uniq
  
  x! "mkdir 'out'"
  
  all.each do |path|
    out = path.gsub(to,"out/")
    
    dir = File.dirname(out)
    if !File.exist?(dir)
      x! "mkdir -p #{dir}" 
    end
    
    x! "cp -rf #{path} #{out}"
  end
end

def dir2xzm from,to
  puts "Making XZM module of #{from}, to, #{to}"
  x! "rm -f #{to}" # overwrite, never append to existing file
  if !x!("mksquashfs #{from} #{to} -b 512K -comp xz -Xbcj x86") #  $3 $4 $5 $6 $7 $8 $9
    return false
  end
  x! "chmod a-wx #{to}" # remove execute and write attrib
  x! "chmod a+r #{to}" # add read for everyone
end

def clean_target()
  x! "rm -rf out/tmp"
  x! "rm -rf out/var/cache/apt/a*/*.deb"
  x! "rm -rf out/usr/share/doc"
end

def do_lite type,from,bool=false
  x! "rm -rf out"
  
  to = "lite/#{type}/"  
  
  `rm -rf #{to}`
  `mkdir -p #{to}`
  system "cp -rf #{from}/* #{to}/"  
  
  if bool
    get_packages("lite",from)     
  end
  
  cmd = "apt-get install -y --force-yes --no-install-recommends #{MODULES[:lite][type].join(" ")}"
  
  x(cmd,to)
  
  x("apt-get clean",to)
  
  do_diff(from,to)
  
  clean_target()
  
  i = [:xorg,:standard,:lxde,:xfce4,:openbox,:xmonad].index(:"#{type}")

  if i > 1 
    i = "1#{i}"
  else
    i = "0#{i}"    
  end
  
  dir2xzm("out","10#{i}-#{"#{type}".upcase}-LITE.xzm")  
end

def do_lite_env env,bool
  from = "lite/standard"
  do_lite(env,from,bool)
end

def do_lite_xorg bool=false
  from = "lite/base"
  do_lite(:xorg,from,bool)
end

def do_lite_standard bool=false
  from = "lite/xorg"
  do_lite(:standard,from,bool)
end


def do_lite_lxde bool=false
  do_lite_env :lxde,bool
end

def do_lite_all(bool,env)
  do_lite_xorg(bool)
  do_lite_standard(bool=false)
  send :"do_lite_#{env}",bool
end