echo "Starting custom programs"

xset r rate 150 20
xset -dpms
setterm -blank 0 -powerdown 0
setxkbmap -option caps:escape
xset s off
sudo rmmod pcspkr

ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
picom &
nm-applet &
blueman-applet &
volumeicon &
blueman-manager &
greenclip daemon &

albert &
copyq &

google-chrome-stable &

emacs --name emacs-main &

slack &
whatsdesk --force-device-scale-factor=1.5 &
