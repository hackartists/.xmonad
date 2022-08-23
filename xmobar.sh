#! /bin/bash

source $HOME/.xmonad/.env

xmobar -x $XMONAD_TRAY_MONITOR --font=$XMOBAR_FONT --position="Static {xpos=$XMOBAR_POS,ypos=$XMOBAR_YPOS,width=$XMOBAR_WIDTH,height=25}" $HOME/.xmonad/xmobarrc.hs
