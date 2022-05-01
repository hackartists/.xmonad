#! /bin/bash

export XMONAD_TRAY_MONITOR=0

trayer --edge top --align center --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor $XMONAD_TRAY_MONITOR --transparent true --alpha 0 --tint 0x282c34  --height 22 --iconspacing 5
