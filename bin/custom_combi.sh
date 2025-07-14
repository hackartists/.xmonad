#!/bin/bash

CMD_CALC="calc: Calculator"
CMD_EMOJI="emoji: Emoticons"
CMD_RUN="run: Run a command"
CMD_DRUN="drun: Run a desktop app"
CMD_CQ="clipboard: Copy from clipboard"
CMD_WM="window: Select a window"
CMD_SS="screenshot: Capture screen"
CMD_MON="monitor: monitor"
CMD_BMK="bookmarks:: Chrome bookmarks"
CMD_KILL="kill: kill a window"
CMD_SCRCPY="scrcpy: mirror mobile screen"
CMD_COLOR="color: color picker"
CMD_DICT="dict: dictionary"
CMD_UC="unicode: unicode symbols"
CMD_PASS="pass: standard password manager"
CMD_TODO="todo: TODO list"
CMD_CAMERA="toggle camera: toggle camera on/off"

if [[ -z "$1" ]]; then
    echo $CMD_CALC
    echo $CMD_EMOJI
    echo $CMD_RUN
    echo $CMD_DRUN
    echo $CMD_CQ
    echo $CMD_WM
    echo $CMD_SS
    echo $CMD_MON
    echo $CMD_BMK
    echo $CMD_KILL
    echo $CMD_SCRCPY
    echo $CMD_COLOR
    # translate-shell package
    echo $CMD_DICT
    echo $CMD_UC
    echo $CMD_PASS
    echo $CMD_TODO
    echo $CMD_CAMERA
fi

case $1 in
    "$CMD_CALC" )
        kill `pidof rofi` 
        rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n '{result}' | xclip -selection clipboard"
        ;;
    "$CMD_DRUN" )
        kill `pidof rofi` 
        rofi -show drun
        ;;
    "$CMD_EMOJI" )
        kill `pidof rofi` 
        rofi -show emoji
        ;;
    "$CMD_RUN" )
        kill `pidof rofi` 
        rofi -show run
        ;;
    "$CMD_WM" )
        kill `pidof rofi` 
        rofi -show window
        ;;
    "$CMD_CQ" )
        kill `pidof rofi` 
        rofi -show clipboard
        ;;
    "$CMD_MON" )
        kill `pidof rofi`
        bash ~/.xmonad/bin/rofi-screen.sh
        ;;
    "$CMD_SS" )
        kill `pidof rofi`
        sleep 0.7
        scrot -s --freeze -e 'xclip -selection clipboard -t image/png -i $f'
        ;;
    "$CMD_KILL" )
        kill `pidof rofi`
        xkill
        ;;
    "$CMD_SCRCPY" )
        kill `pidof rofi`
        scrcpy
        ;;
    "$CMD_COLOR" )
        kill `pidof rofi`
        colorpicker --short --one-shot | xclip -selection clipboard -i
        ;;
    "$CMD_BMK" )
        kill `pidof rofi`
        ~/.local/bin/rofi-browser-bookmarks google-chrome
        ;;
    "$CMD_DICT" )
        kill `pidof rofi`
        echo $(trans "$2")
        ;;
    "$CMD_UC" )
        kill `pidof rofi`
        echo $(rofi -modi "emoji:rofimoji" -show emoji)
        ;;
    "$CMD_PASS")
        kill `pidof rofi`
        ROFI_PASS_BACKEND=wtype ROFI_PASS_CLIPBOARD_BACKEND=wl-clipboard rofi-pass
        ;;
    "$CMD_TODO")
        kill `pidof rofi`
        bash ~/.xmonad/bin/rofi-todos.sh
        ;;
    "$CMD_CAMERA")
        kill `pidof rofi`
        l=`sudo lsmod | grep uvcvideo | wc -l`
        if [ $l -eq 0 ]; then
            sudo modprobe uvcvideo > /dev/null
        else
            sudo rmmod uvcvideo > /dev/null
        fi
        ;;
esac
