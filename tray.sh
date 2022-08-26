#! /bin/bash

source $HOME/.xmonad/.env

trayer --edge top --align center --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor $XMONAD_TRAY_MONITOR --transparent true --alpha 0 --tint 0x282c34  --height $XMONAD_TRAY_HEIGHT --iconspacing 5
