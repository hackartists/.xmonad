#!/bin/sh

# System tray
if [ -z "$(pgrep trayer)" ] ; then
    trayer --edge top \
           --align right \
           --widthtype percent \
           --height 24 \
           --alpha 0 \
           --transparent true \
           --width 5 \
           --tint 0x282c34 &
fi

# Power manager
# if [ -z "$(pgrep xfce4-power-manager)" ] ; then
#     xfce4-power-manager &
# fi

# Taffybar
# if [ -z "$(pgrep taffybar)" ] ; then
#     taffybar &
# fi

# Redshift
if [ -z "$(pgrep redshift)" ] ; then
    redshift &
fi

# Autolock
# if [ -z "$(pgrep xautolock)" ] ; then
    # xautolock -time 1 -locker "if ! grep 'RUNNING' /proc/asound/card*/pcm*/sub*/status;then xscreensaver-command -lock; else echo 'Sound on'; fi"
# fi

# Wallpaper
if [ -z "$(pgrep nitrogen)" ] ; then
    nitrogen --restore &
fi

# Screensaver
# if [ -z "$(pgrep xscreensaver)" ] ; then
#     xscreensaver -no-splash &
# fi

# compton
if [ -z "$(pgrep compton)" ] ; then
    compton -b &
fi

# Network Applet
if [ -z "$(pgrep nm-applet)" ] ; then
    nm-applet &
fi

# Google Drive
if [ -z "$(pgrep insync)" ] ; then
    insync start &
fi

xset r rate 200 30
xset -dpms
setterm -blank 0 -powerdown 0
xset s off
# wallpaper setting
feh --bg-scale ~/Pictures/osw.jpg &

# system tray
# xrandr --dpi 90

stalonetray -c ~/.xmonad/.stalonetrayrc &
/opt/notifier/bin/notifier.AppImage &
albert &
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE="ibus"
ibus-daemon  -drx &
(sleep 5 && copyq) &
/usr/lib/xfce4/notifyd/xfce4-notifyd &

function emacsAlive {
    while [ 1==1 ]; do
        emacs --fg-daemon
    done
}
emacsAlive &

google-chrome &
google-chrome-beta &
noisetorch &
sudo rmmod pcspkr
yakyak &
slack &
NO_AT_BRIDGE=1 evolution &
/opt/appimages/stoplight-studio.AppImage &

# natural mouse scroll
echo "pointer = 1 2 3 5 4 7 6 8 9 10 11 12" > ~/.Xmodmap && xmodmap ~/.Xmodmap

# xbindkeys
xbindkeys
