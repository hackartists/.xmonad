
echo "Starting custom programs"

# lxsession &
# setxkbmap dvorak &
# conky -c $HOME/.config/conky/xmonad.conkyrc

xset r rate 150 50
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
blueman-manager &
blueman-applet &
volumeicon &
greenclip daemon &

albert &
copyq &

google-chrome-stable &

emacs --name emacs-main &

slack &
whatsdesk --force-device-scale-factor=1.5 &
QT_IM_MODULE='ibus' telegram-desktop &
# discord &
# yakyak&
# zoom&
# /opt/notifier/bin/notifier.AppImage&
# autokey-gtk &

mkdir -p ~/data/google-drive/biyard ~/data/google-drive/bylabs ~/data/google-drive/hackartist
rclone mount biyard:/ ~/data/google-drive/biyard --vfs-cache-mode full &
rclone mount biyard-madapp:/ ~/data/google-drive/bylabs --vfs-cache-mode full &


# function google_sync {
#     remote=$1
#     local="$HOME/data/$2"
#     # dir="$HOME/data/$(echo $remote | tr ":" "/")"
#     mkdir -p "$local"
#     echo Starting syncing ${remote} into ${local}
#     while true
#     do
#         rclone -v bisync "$remote" "${local}" --exclude=/참고자료/** --drive-allow-import-name-change --resync 
#         sleep 300
#     done
# }

# google_sync "bylabs:Projects/[인천광역시] 블록체인 허브도시 인천 조성 연구용역" "bylabs/ihub" &
# google_sync "biyard:Admin & Compliance" "biyard/admin" &

rclone mount hackartist:/ ~/data/google-drive/hackartist --vfs-cache-mode full &
# sshfs -o default_permissions server:/home/hackartist ~/data/server &
# wine "/home/hackartist/.wine/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe"
