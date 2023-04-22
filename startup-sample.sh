echo "Starting custom programs"

# lxsession &
# setxkbmap dvorak &
# conky -c $HOME/.config/conky/xmonad.conkyrc

xset r rate 150 20
xset s off -dpms
# setterm -blank 0 -powerdown 0
setxkbmap -option caps:escape
sudo rmmod pcspkr
xrdb ~/.Xresources && xrdb -merge ~/.Xresources

ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
picom &
nm-applet &
pa-applet &
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
QT_IM_MODULE='ibus' telegram-desktop &
discord &
# yakyak&
# zoom&
/opt/notifier/bin/notifier.AppImage&
autokey-gtk &

rclone mount biyard:/ ~/data/google-drive/biyard &
rclone mount biyard-madapp:/ ~/data/google-drive/biyard-madapp &
rclone mount hackartist:/ ~/data/google-drive/hackartist &

# wine "/home/hackartist/.wine/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe"
