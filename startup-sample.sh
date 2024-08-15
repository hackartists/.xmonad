echo "Starting custom programs"
export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export XMODIFIERS='@im=ibus'
export GLFW_IM_MODULE=ibus
export XDG_SESSION_TYPE=x11

# lxsession &
# setxkbmap dvorak &
# conky -c $HOME/.config/conky/xmonad.conkyrc

# xset r rate 150 30
xset r rate 150 50
# xset r rate 200 15
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
blueman-manager &
blueman-applet &
volumeicon &
greenclip daemon &

# albert &
copyq &

google-chrome-stable &
# google-chrome-unstable --user-agent="Mozilla/5.0 (Windows NT6.4; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" https://www.figma.com/ &
google-chrome-beta &

emacs --name emacs-main &

slack -u&

function im-uim {
    QT_IM_MODULE='uim' GTK_IM_MODULE='uim' XMODIFIERS='@im=uim' $@
}

QT_IM_MODULE='uim' GTK_IM_MODULE='uim' XMODIFIERS='@im=uim' im-uim whatsdesk & ## --force-device-scale-factor=1.5 &
# telegram-desktop --no-startup-window &
discord --start-minimized &

# autokey-gtk &

mkdir -p ~/data/google-drive/biyard ~/data/google-drive/bylabs ~/data/google-drive/hackartist
function mount_cloud_storage {
    account=$1
    dir=$2

    while true
    do
        rclone mount "$account:/" "$dir" --dir-cache-time 1d --vfs-cache-max-age 3600h --vfs-cache-max-size 500G --vfs-refresh --vfs-cache-mode full --drive-server-side-across-configs
    done
}
mount_cloud_storage config-name $HOME/data/google-drive/dir-name &

function sync_cloud_storage {
    remote=$1
    local="$HOME/data/$2"
    # dir="$HOME/data/$(echo $remote | tr ":" "/")"
    mkdir -p "$local"
    echo Starting syncing ${remote} into ${local}
    while true
    do
        rclone -v bisync "$remote" "${local}" --drive-server-side-across-configs --resync # --drive-allow-import-name-change 
        sleep 300
    done
}
sync_cloud_storage "config-name:Cloud Dirname" "dir-name" &

# ollama serve &

function pull_home {
    cd ~/.emacs_anywhere && git pull && cd ..  &
    cd ~/.oh-my-profiles && git pull && cd .. &
    cd ~/.xmonad && git pull && cd .. &
    cd ~/.config && git pull && cd .. &
    cd ~/.gnupg && git pull && cd .. &
    cd ~/.emacs.d && git pull && cd .. &
    cd ~/.password-store && git pull && cd .. &
    cd ~/data/devel/github.com/hackartists/notes/ && git pull && cd ~ &
}
# pull_home &

# sshfs -o default_permissions server:/home/hackartist ~/data/server &

PYTHONPATH=$HOME/.xmonad/py python -m ranger-dbus.py &
/usr/lib/xdg-desktop-portal-termfilechooser -c $HOME/.config/xdg-desktop-portal-termfilechooser/config -l DEBUG &
