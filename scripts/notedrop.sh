#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

if [ -z "$(ps aux | grep -w todo | grep -v grep | awk '{print $2}')" ];
then
    st -n notedrop \
       -e vim ~/Dropbox/Notes/todo.md
fi

#-f "hack:pixelsize=17:antialias=false:autohint=true" \
