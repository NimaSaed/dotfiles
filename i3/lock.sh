#!/bin/bash
ICON=~/.config/i3/lock-icon.png
TMPBG=/tmp/screen.png
secondScreen off
sleep 0.1
scrot -z /tmp/screen.png
convert $TMPBG -scale 10% -scale 1000% $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
i3lock -e -i $TMPBG
rm -f $TMPBG
sleep 0.2
