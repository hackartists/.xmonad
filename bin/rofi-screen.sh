#!/usr/bin/env bash

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
    echo "$OPT9"
    echo "$OPT3"
    echo "$OPT2"
    echo "$OPT4"
    echo "$OPT1"
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
            xrandr --output DP-4 --auto
            xrandr --output DP-0 --same-as DP-4 --auto
            ;;
        "$OPT5")
            xrandr --output DP-4 --auto
            xrandr --output DP-0 --auto --right-of DP-4
            ;;
        "$OPT6")
            xrandr --output DP-4 --auto
            xrandr --output HDMI-0 --off
            xrandr --output DP-0 --off
            ;;
        "$OPT7")
            xrandr --output HDMI-0 --same-as DP-4 --auto
            ;;
        "$OPT8")
            xrandr --output DP-4 --auto
            xrandr --output HDMI-0 --auto --right-of DP-4
            ;;
        "$OPT9")
            xrandr --output DP-4 --mode 5120x1440 --output HDMI-0 --off
            ;;
    esac
}

main "$@" &

exit 0
