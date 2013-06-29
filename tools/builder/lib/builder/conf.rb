NO_RECMD = "--no-install-recommends"

XORG = {
  :name=>'xorg'  
}


XORG_NOREC = {
  :name=>'xorg',
  :opts=>NO_RECMD
}

LITE = {
  :lxde=>{
          :packages=>[
                      {
                       :name=>'task-lxde-desktop',
                       :opts=>NO_RECMD
                      }
                     ]
         },
  :xfce=>{
          :packages=>[
                      {
                       :name=>'task-xfce-desktop',
                       :opts=>NO_RECMD
                      }
                     ]
         },
  :openbox=>{
          :packages=>[
                      {
                       :name=>'openbox',
                       :opts=>NO_RECMD
                      },
                      XORG_NOREC
                     ]
         }, 
  :xmonad=>{
          :packages=>[
                      {
                       :name=>'xmonad',
                       :opts=>NO_RECMD
                      },
                      {
                       :name=>'dmenu'
                      },
                      XORG_NOREC
                     ]
         },
  :xorg=>{
          :packages=>[
                      XORG_NOREC
                     ]
         }
}

FULL = {
  :lxde=>{
          :packages=>[
                      {
                       :name=>'task-lxde-desktop'
                      }
                     ]
         },
  :xfce=>{
          :packages=>[
                      {
                       :name=>'task-xfce-desktop'
                      }
                     ]
         },
  :openbox=>{
          :packages=>[
                      {
                       :name=>'openbox'
                      },
                      XORG
                     ]
         }, 
  :xmonad=>{
          :packages=>[
                      {
                       :name=>'xmonad'
                      },
                      {
                       :name=>'dmenu'
                      },
                      XORG
                     ]
         },
  :xorg=>{
          :packages=>[
                      XORG
                     ]
         }
}

APPS = {
  :lite=>{
          :packages => [
                        {
                         :name=>'lxterminal'
                        },
                        {
                         :name => 'gedit',
                         :opts => NO_RECMD
                        },
                        {
                         :name => 'mplayer'
                        },
                        {
                         :name => 'moc'
                        },
                        {
                         :name => 'mpg321'
                        },
                        {
                         :name => 'rxvt-unicode'
                        },
                        {
                         :name => 'xcompmgr'
                        },
                        {
                         :name => 'feh'
                        }
                       ]
         }
}

MODULES = {:full=>{},:lite=>{}}

WORK = File.join(ENV['HOME'],".work","build")
