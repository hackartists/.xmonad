

echo "Starting custom programs"
export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export XMODIFIERS='@im=ibus'

# lxsession &
# setxkbmap dvorak &
# conky -c $HOME/.config/conky/xmonad.conkyrc

# xset r rate 150 30
# xset r rate 150 50
xset r rate 200 30
xset s off -dpms
# setterm -blank 0 -powerdown 0
setxkbmap -option caps:escape
sudo rmmod pcspkr
xrdb ~/.Xresources && xrdb -merge ~/.Xresources

gsettings set org.freedesktop.ibus.engine.hangul use-event-forwarding false
ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3 &
uim-xim&
# sudo ~/.xmonad/bin/dns

/usr/lib/xfce4/notifyd/xfce4-notifyd &
picom &
nm-applet &
pa-applet &
# blueman-manager &
# blueman-applet &
volumeicon &
greenclip daemon &

# albert &
copyq &

google-chrome-stable &
google-chrome-unstable --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" https://www.figma.com/ &
google-chrome-beta &

emacs --name emacs-main &

slack &
chatall &

function im-uim {
    QT_IM_MODULE='uim' GTK_IM_MODULE='uim' XMODIFIERS='@im=uim' $@
}

im-uim whatsdesk --force-device-scale-factor=1.5 &
telegram-desktop &

discord &
# yakyak&
# zoom&
# /opt/notifier/bin/notifier.AppImage&
# autokey-gtk &

mkdir -p ~/data/google-drive/biyard ~/data/google-drive/bylabs ~/data/google-drive/hackartist
function google_mount {
    account=$1
    dir=$2

    while true
    do
        rclone mount "$account:/" "$dir" --vfs-cache-mode full --vfs-cache-max-size=500G --vfs-cache-max-age=3600h --vfs-refresh --vfs-fast-fingerprint --drive-server-side-across-configs
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
        rclone -v bisync "$remote" "${local}" --drive-server-side-across-configs --resync # --drive-allow-import-name-change 
        # rclone -v bisync "$remote" "${local}" --exclude=/참고자료/** --drive-allow-import-name-change --resync 
        sleep 300
    done
}

google_sync "bylabs:Design sources" "design-sources" &
# google_sync "biyard:Admin & Compliance" "biyard/admin" &
onedrive -m --syncdir ~/data/onedrive/hackartist --disable-notifications --display-sync-status&
# sshfs -o default_permissions server:/home/hackartist ~/data/server &
# wine "/home/hackartist/.wine/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe"
vmware &
yay -Syyu --noconfirm
