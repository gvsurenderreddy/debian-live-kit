command :all, :with_opts=>[:iso,:all,:clean,:splash] do
  iso = Dir.glob(File.expand_path(OPTIONS[:iso]))[0]  
  
  init()
  
  inflate_porteus(iso,from="porteus-source")
  init_debian(from,target="target")
  
  extract_porteus(from)
  strip_porteus(target)
  
  init_base()
  pack(target)
  
  mkdeb(target)
  
  clean(OPTIONS[:clean])
end

command :init, :with_opts=>[:init] do
  init()
  init_base()
end

command :pack, :with_opts=>[:pack,:target] do
  target = "target"
  target = File.expand_path(OPTIONS[:target]) if OPTIONS[:target]
  
  init()
  pack(target)
end

command :finalize, :with_opts=>[:finalize,:target,:splash] do
  target = "target"
  target = File.expand_path(OPTIONS[:target]) if OPTIONS[:target]
  
  init()
  mkdeb(target)
end

command :pen, :with_opts=>[:pen,:device,:from] do
  from = "target"  
  from = File.expand_path(OPTIONS[:from]) if OPTIONS[:from]
  
  init()
  mkpen(OPTIONS[:device],from)
end

command :extract, :with_opts=>[:extract] do
  from = "porteus-source"  
  from = File.expand_path(OPTIONS[:from]) if OPTIONS[:from] 
  
  init()
  extract_porteus(from)
end

command :modify, :with_opts=>[:modify] do
  init()
  
  unpack("target","modit")
  modify("modit")
  pack("target")
end

command :import, :with_opts=>[:import,:source] do
  if !OPTIONS[:source]
    puts OPTION_PARSER
    puts "no source specified"
  end
  
  from = File.expand_path(OPTIONS[:source])
  
  init()
  
  echo "Import build\nThis will overwrite current tree."
  
  resp = nil
  
  loop do
    echo "Are you sure? [Y/n]"
    resp = gets.chomp
    
    break if resp == "y" or resp == "Y" or resp == "n" or resp == "N"
  end
  
  if resp.downcase == "y"
  
  else
    echo "Aborted."
    exit(1)
  end

  x "rm -rf target/*"
  x "cp -rf #{from}/* target/"
  x "cp #{from}/*/modules/* modules/"
end