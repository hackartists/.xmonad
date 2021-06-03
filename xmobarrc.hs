-- Config {
--        , additionalFonts = [ "xft:FontAwesome:size=11" ]
--        , allDesktops = True
--        , bgColor = "#282c34"
--        , fgColor = "#bbc2cf"
--        , iconRoot = "~/.xmonad/xpm/"  -- default: "."
--        , position = Static { xpos = 3840 , ypos = 0, width = 3839, height = 25 }
--        , commands = [ Run Network "enp6s0" ["-t", "<fn=2>\xf0ab</fn>  <rx>kb  <fn=2>\xf0aa</fn>  <tx>kb"] 20
--                       -- Cpu usage in percent
--                     , Run Cpu ["-t", "<fn=2>\xf108</fn>  cpu: (<total>%)","-H","50","--high","red"] 20
--                       -- Ram used number and percent
--                     , Run Memory ["-t", "<fn=2>\xf233</fn>  mem: <used>M (<usedratio>%)"] 20
--                       -- Disk space free
--                     , Run DiskU [("/", "<fn=2>\xf0c7</fn>  hdd: <free> free")] [] 60

--                     , Run Date "<fc=#ECBE7B><fn=1></fn></fc> %a %b %_d %I:%M" "date" 300
--                     , Run DynNetwork ["-t","<fc=#4db5bd><fn=1></fn></fc> <rx>, <fc=#c678dd><fn=1></fn></fc> <tx>"
--                                      ,"-H","200"
--                                      ,"-L","10"
--                                      ,"-h","#bbc2cf"
--                                      ,"-l","#bbc2cf"
--                                      ,"-n","#bbc2cf"] 50

--                     , Run CoreTemp ["-t", "<fc=#CDB464><fn=1></fn></fc> <core0>°"
--                                    , "-L", "30"
--                                    , "-H", "75"
--                                    , "-l", "lightblue"
--                                    , "-n", "#bbc2cf"
--                                    , "-h", "#aa4450"] 50

--                     -- battery monitor
--                     , Run BatteryP       [ "BAT0" ]
--                                          [ "--template" , "<fc=#B1DE76><fn=1></fn></fc> <acstatus>"
--                                          , "--Low"      , "10"        -- units: %
--                                          , "--High"     , "80"        -- units: %
--                                          , "--low"      , "#fb4934" -- #ff5555
--                                          , "--normal"   , "#bbc2cf"
--                                          , "--high"     , "#98be65"

--                                          , "--" -- battery specific options
--                                                    -- discharging status
--                                                    , "-o"   , "<left>% (<timeleft>)"
--                                                    -- AC "on" status
--                                                    , "-O"   , "<left>% (<fc=#98be65>Charging</fc>)" -- 50fa7b
--                                                    -- charged status
--                                                    , "-i"   , "<fc=#98be65>Charged</fc>"
--                                          ] 50
--                     , Run Com "~/.local/bin/pacupdate" [] "pacupdate" 3600
--                       -- Runs a standard shell command 'uname -r' to get kernel version
--                     , Run Com "uname" ["-r"] "" 3600
--                     , Run Com "~/.config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
--                     , Run StdinReader
--                     -- , Run GMail "js.choi.85" "password" ["-t", "Mail: <count>"] 3000
--                     ]
--        , sepChar = "%"
--        , alignSep = "}{"
--        , template = " <icon=haskell_20.xpm/>   <fc=#666666>|</fc> %UnsafeStdinReader% }{  <fc=#666666>|</fc>  <fc=#b3afc2><fn=3></fn>  <action=`alacritty -e htop`>%uname%</action> </fc> <fc=#666666>|</fc>  <fc=#ecbe7b> <action=`alacritty -e htop`>%cpu%</action> </fc> <fc=#666666>|</fc>  <fc=#ff6c6b> <action=`alacritty -e htop`>%memory%</action> </fc> <fc=#666666>|</fc>  <fc=#51afef> <action=`alacritty -e htop`>%disku%</action> </fc> <fc=#666666>|</fc>  <fc=#98be65> <action=`alacritty -e sudo iftop`>%enp6s0%</action> </fc> <fc=#666666>|</fc>   <fc=#c678dd><fn=2></fn>  <action=`alacritty -e sudo pacman -Syu`>%pacupdate%</action> </fc> <fc=#666666>|</fc>  <fc=#46d9ff> <action=`emacsclient -c -a 'emacs' --eval '(calendar)'`>%date%</action>  </fc> %trayerpad%""
--        }
-- http://projects.haskell.org/xmobar/
-- I use Font Awesome 5 fonts in this config for unicode "icons".  On Arch Linux,
-- install this package from the AUR to get these fonts: otf-font-awesome-5-free

Config {
       font = "xft:NanumGothic:size=11:bold:antialias=true"
       , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=11:antialias=true:hinting=true"
                           , "xft:Font Awesome 5 Free Solid:pixelsize=12"
                           , "xft:Font Awesome 5 Brands:pixelsize=12"
                           ]
       , bgColor = "#282c34"
       , fgColor = "#ff6c6b"
       , position = Static { xpos = 3840 , ypos = 0, width = 3839, height = 25 }
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "~/.xmonad/xpm/"  -- default: "."
       , commands = [
                    -- Time and date
                      Run Date "<fn=2>\xf017</fn>  %b %d %Y - (%H:%M) " "date" 50
                      -- Network up and down
                    , Run Network "eth0" ["-t", "<fn=2>\xf0ab</fn>  <rx>kb  <fn=2>\xf0aa</fn>  <tx>kb"] 20
                      -- Cpu usage in percent
                    , Run Cpu ["-t", "<fn=2>\xf108</fn>  cpu: (<total>%)","-H","50","--high","red"] 20
                      -- Ram used number and percent
                    , Run Memory ["-t", "<fn=2>\xf233</fn>  mem: <used>M (<usedratio>%)"] 20
                      -- Disk space free
                    , Run DiskU [("/", "<fn=2>\xf0c7</fn>  hdd: <free> free")] [] 60
                      -- Runs custom script to check for pacman updates.
                      -- This script is in my dotfiles repo in .local/bin.
                    , Run Com "bash" ["-c", "~/.local/bin/pacupdate"] "updates" 3600
                      -- Runs a standard shell command 'uname -r' to get kernel version
                    , Run Com "uname" ["-r"] "" 3600
                      -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
                    , Run Com "~/.config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
                      -- Prints out the left side items such as workspaces, layout, etc.
                      -- The workspaces are 'clickable' in my configs.
                    , Run Com "gh" ["api", "notifications", "-q", "length"] "" 30
                    , Run UnsafeStdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " <icon=haskell_20.xpm/>   <fc=#666666>|</fc> %UnsafeStdinReader% }{ <fc=#666666>|</fc>  <fc=#b3afc2><fn=3></fn>  <action=`xdg-open https://github.com/notifications`>GH-%gh%</action> </fc> <fc=#666666>|</fc>  <fc=#b3afc2><fn=3></fn>  <action=`alacritty -e htop`>%uname%</action> </fc> <fc=#666666>|</fc>  <fc=#ecbe7b> <action=`alacritty -e htop`>%cpu%</action> </fc> <fc=#666666>|</fc>  <fc=#ff6c6b> <action=`alacritty -e htop`>%memory%</action> </fc> <fc=#666666>|</fc>  <fc=#51afef> <action=`alacritty -e htop`>%disku%</action> </fc> <fc=#666666>|</fc>   <fc=#c678dd><fn=2></fn>  <action=`alacritty -e sudo pacman -Syu`>%updates%</action> </fc> <fc=#666666>|</fc>  <fc=#46d9ff> <action=`emacsclient -c -a 'emacs' --eval '(maximize-window (calendar))'`>%date%</action> </fc><fc=#666666><fn=1>|</fn></fc>"
       }
