#! /bin/bash

source $HOME/.xmonad/.env

if [ "$XMOBAR_WIDTH" == "" ]
then
    XMOBAR_WIDTH=`xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/' | sed -r 's/x.*//'`
fi

xmobar -x $XMONAD_TRAY_MONITOR --font=$XMOBAR_FONT --position="Static {xpos=$XMOBAR_POS,ypos=$XMOBAR_YPOS,width=$XMOBAR_WIDTH,height=25}" $HOME/.xmonad/xmobarrc.hs
