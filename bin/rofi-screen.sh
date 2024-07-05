#!/usr/bin/env bash

D=DP-4
S=DP-0
H=HDMI-1
OPT1="OdysseyG9: 3-screens and bottom"
OPT2="OdysseyG9: full-screen and bottom"
OPT3="OdysseyG9: full-screen and off"
OPT4="Mirror: USB-C FHD"
OPT5="Extend: USB-C FHD"
OPT6="One"
OPT7="Mirror: HDMI"
OPT8="Extend: HDMI"
OPT9="OdysseyG9: One on DP"

get_options() {
    # echo "$OPT9"
    # echo "$OPT3"
    # echo "$OPT2"
    echo "$OPT4"
    # echo "$OPT1"
    echo "$OPT5"
    echo "$OPT6"
    echo "$OPT7"
    echo "$OPT8"
}

main() {
    choice=$( (get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" )

    if [[ -z "${choice// }" ]]; then
        exit 1
    fi

    case $choice in
        "$OPT1")
            xrandr --setmonitor VIRTUAL-LEFT 1280/297x1440/340+0+0 none
            xrandr --setmonitor VIRTUAL-CENTER 2560/596x1440/340+1280+0 HDMI-0
            xrandr --setmonitor VIRTUAL-RIGHT 1280/297x1440/340+3840+0 none
            xrandr --fb 5120x1440
            # xrandr --setmonitor ODYSSEY~1 1280/2980x1440/3350+0+0 HDMI-0
            # xrandr --setmonitor ODYSSEY~2 2560/5960x1440/3350+1280+0 none
            # xrandr --setmonitor ODYSSEY~3 1280/2980x1440/3350+3840+0 none
            xrandr --output VIRTUAL-CENTER --mode 2560x1440 --output VIRTUAL-LEFT --mode 1280x1440 --left-of VIRTUAL-CENTER --output VIRTUAL-RIGHT --mode 1280x1440 --right-of VIRTUAL-CENTER
            ;;
        "$OPT2")
            xrandr --output HDMI-0 --mode 5120x1440 --output DP-4 --off
            xrandr --output DP-4 --mode 1920x1080 --pos 1600x1440
            ;;
        "$OPT3")
            xrandr --output HDMI-0 --mode 5120x1440 --output DP-4 --off
            ;;
        "$OPT4")
            xrandr --output $D --auto
            xrandr --output $S --same-as DP-4 --auto
            ;;
        "$OPT5")
            xrandr --output $D --auto
            xrandr --output $S --auto --right-of $D
            ;;
        "$OPT6")
            xrandr --output $D --auto
            xrandr --output $H --off
            xrandr --output $S --off
            ;;
        "$OPT7")
            xrandr --output $H --same-as $D --auto
            ;;
        "$OPT8")
            xrandr --output $D --auto
            xrandr --output $H --auto --right-of $D
            ;;
        "$OPT9")
            xrandr --output $D --mode 5120x1440 --output $H --off
            ;;
    esac
}

main "$@" &

exit 0
