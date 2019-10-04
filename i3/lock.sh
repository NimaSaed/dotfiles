#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

# Get latest image from bing images folder
IMG=$HOME/Dropbox/bing_images/$(ls -r $HOME/Dropbox/bing_images/ | grep -m 1 bing)

# Set lock icon
ICON=~/.config/i3/lock-icon.png

# Set path to save the modified image
TMPBG=/tmp/lock

# Add the lock icon to the center of the bing image
convert $IMG $ICON -gravity center -composite -matte -format PNG $TMPBG.png

# Start i3lock with black color, disable mouse and set the created image
i3lock -c 000000 -e -i $TMPBG.png

# To give some time to i3lock to load the image before suspend happen
sleep 0.2
