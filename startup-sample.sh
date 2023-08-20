
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
gsettings set org.freedesktop.ibus.engine.hangul use-event-forwarding false
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

mkdir -p ~/data/google-drive/biyard-admin ~/data/google-drive/biyard ~/data/google-drive/bylabs ~/data/google-drive/hackartist

function google_mount {
    account=$1
    dir=$2

    while true
    do
        rclone mount "$account:/" "$dir" --vfs-cache-mode full
    done
}
google_mount biyard ~/data/google-drive/biyard &
google_mount biyard-admin ~/data/google-drive/biyard-admin &
google_mount biyard-madapp ~/data/google-drive/bylabs &
google_mount hackartist ~/data/google-drive/hackartist &

function google_sync {
    remote=$1
    local="$HOME/data/$2"
    # dir="$HOME/data/$(echo $remote | tr ":" "/")"
    mkdir -p "$local"
    echo Starting syncing ${remote} into ${local}
    while true
    do
        rclone -v bisync "$remote" "${local}" --drive-allow-import-name-change --resync 
        # rclone -v bisync "$remote" "${local}" --exclude=/참고자료/** --drive-allow-import-name-change --resync 
        sleep 300
    done
}

