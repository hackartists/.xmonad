
Config {
       -- font = "xft:NanumGothic:size=11:bold:antialias=true"
       additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=11:antialias=true:hinting=true"
                           , "xft:Font Awesome 5 Free Solid:pixelsize=12"
                           , "xft:Font Awesome 5 Brands:pixelsize=12"
                           ]
       , bgColor = "#282c34"
       , fgColor = "#ff6c6b"
       -- , position = Static { xpos = 3840 , ypos = 0, width = 3839, height = 25 }
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "~/.xmonad/xpm/"  -- default: "."
       , commands = [
                      Run Date "%y/%m/%d %H:%M" "date" 50
                    , Run Battery [
	                "-t",
                        "<left>%-<timeleft>",
	                "--",
	                --"-c", "charge_full",
	                "-O", "AC",
	                "-o", "Bat",
	                "-h", "green",
	                "-l", "red"
	                ] 10
                    , Run Network "eth0" ["-t", "<rx>kb  <fn=2>\xf0aa</fn>  <tx>kb"] 20
                    , Run Cpu ["-t", "<total>%","-H","50","--high","red"] 20
                    , Run Memory ["-t", "<used>M"] 20
                    , Run DiskU [("/", "<free>")] [] 60
                    , Run Com "bash" ["-c", "~/.xmonad/bin/pacupdate"] "updates" 3600
                    , Run Com "bash" ["-c", "~/.xmonad/bin/mouselocation"] "mouselocation" 1
                    , Run Com "bash" ["-c", "~/.xmonad/bin/volume"] "volume" 1
                    , Run Com "uname" ["-r"] "" 3600
                    , Run Com "bash" ["-c", "~/.xmonad/gh-notify.sh"] "gh" 300
                    , Run UnsafeStdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " <icon=haskell_20.xpm/>   <fc=#666666>|</fc> %UnsafeStdinReader% }{ <fc=#c678dd>%mouselocation%</fc> <fc=#b3afc2> %battery% </fc> <fc=#b3afc2> VL%volume% </fc> <fc=#b3afc2> <action=`xdg-open https://github.com/notifications`>GH %gh%</action> </fc> <fc=#b3afc2> <action=`alacritty -e htop`>%uname%</action> </fc> <fc=#ecbe7b> <action=`alacritty -e htop`>%cpu%</action> </fc> <fc=#ff6c6b> <action=`alacritty -e htop`>%memory%</action> </fc> <fc=#51afef> <action=`alacritty -e htop`>%disku%</action> </fc> <fc=#c678dd> <action=`alacritty -e sudo pacman -Syu`>%updates%</action> </fc>  <fc=#46d9ff> <action=`emacsclient -n --eval '(cfw:open-org-calendar)'`>%date%</action> </fc><fc=#666666><fn=1>|</fn></fc>"
       }
