#! /bin/bash

export XMOBAR_FONT=xft:NanumGothic:size=9:bold:antialias=true
export XMONAD_TRAY_MONITOR=0

xmobar -x 0 --font=$XMOBAR_FONT --position='Static {xpos=0,ypos=0,width=2880,height=25}' $HOME/.xmonad/xmobarrc.hs
