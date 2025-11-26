#! /bin/bash

source $HOME/.xmonad/.env

if [ -z "$XMOBAR_WIDTH" ]
then
    XMOBAR_WIDTH=$(xrandr --query | grep -w primary | awk '{print $4}' | sed -r 's/x.*//')
fi

if [ -z "$XMOBAR_POS" ]
then
    XMOBAR_POS=$(xrandr --query | grep -w primary | awk '{print $4}' | sed -r 's/^[0-9]+x[0-9]+\+//;s/\+.*//')
fi

if [ -z "$XMOBAR_YPOS" ]
then
    XMOBAR_YPOS=$(xrandr --query | grep -w primary | awk '{print $4}' | sed -r 's/.*\+//')
fi

if [ -z "$XMONAD_TRAY_MONITOR" ]
then
    if command -v xrandr >/dev/null 2>&1
    then
        XMONAD_TRAY_MONITOR=$(xrandr --listmonitors 2>/dev/null | awk '/\*/ {print $1}' | tr -d ':')
        if [ -z "$XMONAD_TRAY_MONITOR" ]
        then
            PRIMARY_NAME=$(xrandr --query | awk '/ connected primary/ {print $1; exit}')
            if [ -n "$PRIMARY_NAME" ]
            then
                XMONAD_TRAY_MONITOR=$(xrandr --listmonitors 2>/dev/null | awk -v name="$PRIMARY_NAME" '$0 ~ name {print $1}' | tr -d ':')
            fi
        fi
    fi

    if [ -z "$XMONAD_TRAY_MONITOR" ]
    then
        XMONAD_TRAY_MONITOR=0
    fi
fi

# TOTAL_MONITORS=$(xrandr --listmonitors | awk '/Monitors:/ {print $2}')

# if [ "$TOTAL_MONITORS" -ge "3" ]
# then
#     XMONAD_TRAY_MONITOR=$((XMONAD_TRAY_MONITOR + 1))
# else
#     XMONAD_TRAY_MONITOR=$((XMONAD_TRAY_MONITOR))
# fi

pkill -TERM trayer
sleep 0.1

trayer --edge top --align center --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor primary --transparent true --alpha 0 --tint 0x282c34  --height $XMONAD_TRAY_HEIGHT --iconspacing 5 &

xmobar -x $XMONAD_TRAY_MONITOR --font=$XMOBAR_FONT --position="Static {xpos=$XMOBAR_POS,ypos=$XMOBAR_YPOS,width=$XMOBAR_WIDTH,height=$XMOBAR_HEIGHT}" $HOME/.xmonad/xmobarrc.hs 
