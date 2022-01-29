Config {
       font = "xft:NanumGothic:size=8:bold:antialias=true"
       , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=8:antialias=true:hinting=true"
                           , "xft:Font Awesome 5 Free Solid:pixelsize=12"
                           , "xft:Font Awesome 5 Brands:pixelsize=12"
                           ]
       , bgColor = "#282c34"
       , fgColor = "#ff6c6b"
       -- , position = Static { xpos = 3840, ypos = 0, width = 3840, height = 30 }
       , position = Static { xpos = 0, ypos = 0, width = 2879, height = 25 }
       -- , position = Static { xpos = 0, ypos = 0, width = 3840, height = 25 }
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "~/.xmonad/xpm/"  -- default: "."
       , commands = [
           -- Time and date
           Run Date "%b %d %Y - (%H:%M) " "date" 50
             -- Network up and down
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
             -- Cpu usage in percent
           , Run Cpu ["-t", "<total>%","-H","50","--high","red"] 20
             -- Ram used number and percent
           , Run Memory ["-t", "<used>M"] 20
             -- Disk space free
           , Run DiskU [("/", "<free> free")] [] 60
             -- Runs custom script to check for pacman updates.
             -- This script is in my dotfiles repo in .local/bin.
           , Run Com "bash" ["-c", "~/.local/bin/pacupdate"] "updates" 3600
           , Run Com "bash" ["-c", "~/.local/bin/mouselocation"] "mouselocation" 1
           -- Runs a standard shell command 'uname -r' to get kernel version
           , Run Com "uname" ["-r"] "" 3600
             -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
           , Run Com "~/.config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
             -- Prints out the left side items such as workspaces, layout, etc.
             -- The workspaces are 'clickable' in my configs.
           , Run Com "gh" ["api", "notifications", "-q", "length"] "" 30
           , Run Com "bash" ["-c", "~/.xmonad/bin/emacsd.sh"] "emacsd" 36000
           , Run UnsafeStdinReader
           ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " <icon=haskell_20.xpm/>   <fc=#666666>|</fc> %UnsafeStdinReader% }{ <fc=#666666>|</fc>   <fc=#c678dd>%mouselocation%</fc> <fc=#666666>|</fc>  <fc=#b3afc2> <action=`xdg-open https://github.com/notifications`>GH-%gh%</action> </fc> <fc=#666666>|</fc>  <fc=#b3afc2> <action=`alacritty -e htop`>%uname%</action> <fc=#666666>|</fc>  <fc=#b3afc2> %battery% </fc> </fc> <fc=#666666>|</fc>  <fc=#ecbe7b> <action=`alacritty -e htop`>%cpu%</action> </fc> <fc=#666666>|</fc>  <fc=#ff6c6b> <action=`alacritty -e htop`>%memory%</action> </fc> <fc=#666666>|</fc>  <fc=#51afef> <action=`alacritty -e htop`>%disku%</action> </fc> <fc=#666666>|</fc>   <fc=#c678dd> <action=`alacritty -e sudo pacman -Syu`>%updates%</action> </fc> <fc=#666666>|</fc>  <fc=#46d9ff> <action=`emacsclient -n --eval '(calendar)'`>%date%</action> </fc><fc=#666666><fn=1>|</fn></fc>"
       }
