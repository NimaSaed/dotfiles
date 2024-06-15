#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

# To open spotfiy if it is not open and play the music, otherwise play the music

spotifyStatus=$(ps aux | grep -iw \/opt\/spotify | grep -v grep)

if [ -n "$spotifyStatus" ];
then
    playerctl play-pause
else
    spotify &> /dev/null &
    sleep 0.5
    playerctl play-pause
fi

exit 0
