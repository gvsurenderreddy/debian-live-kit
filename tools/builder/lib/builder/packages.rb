def list2ary file
  if q=open(file).read.match(/NEW.*?installed\:(.*?)[0-9]+ upgraded\,/m)
    return q[1].gsub("\n"," ").split(' ')
  end
  []
end

def env2pkgs(env,conf,chroot)
  a=conf[:packages].map do |pkg|
    value = [pkg[:opts],pkg[:name]].join(" ").strip
    system("chroot #{chroot} apt-get -s install #{value} > #{file="#{env}_#{pkg[:name]}.list"}")
    list2ary(file)
  end
  
  a=a.flatten.uniq
  
  return a
end

def get_packages(type,chroot)
  type = :"#{type}"
  packages = {}
  pary = []

  q = LITE
  q = FULL if type == :full
  
  q.each_pair do |env,conf|
    conf[:packages].push(*APPS[type][:packages]) unless env == :xorg
    a = env2pkgs(env,conf,chroot)
    packages[env] = a
    pary << a unless env == :xorg
  end

  MODULES[type][:xorg] = packages[:xorg]



  common = pary.shift
  pary.each do |set|
    common = common & set
  end

  def strip_set set,from
    from.find_all do |pkg|
      !set.index(pkg)
    end  
  end

  common = strip_set(MODULES[type][:xorg],common)

  MODULES[type][:standard] = common


  LITE.each_pair do |env,conf|
    next if env == :xorg
    set = packages[env]
    set = strip_set(MODULES[type][:standard],set)
    set = strip_set(MODULES[type][:xorg],set)
    
    MODULES[type][env] = set
  end
end