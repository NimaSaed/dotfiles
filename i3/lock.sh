#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

bing_images_path="$HOME/Dropbox/bing_images"

# Set path to save the modified image
TMPBG=/tmp/lock

# Set lock icon
ICON=/tmp/lock-icon.png
if [ ! -s $ICON ];
then
    cp ~/.config/i3/lock-icon.png /tmp/
    convert -resize 149% $ICON $ICON
fi

# Run bing-background to get latest picture if it is not there
IMG="$(ls $bing_images_path | grep $(date +%Y-%m-%d))"
if [ -z "$IMG" ];
then
    bing-background 0
    IMG="$(ls $bing_images_path | grep $(date +%Y-%m-%d))"
fi

# latest image from bing images folder
IMG_path=/tmp/$IMG

if [ ! -s $IMG_path ];
then
    cp $bing_images_path/$IMG /tmp/
    # convert the image for 4k and 1080p monitors
    convert -resize 3840x2160 $IMG_path $TMPBG-bing4k.png
    convert -resize 150% $IMG_path $TMPBG-bing150.png
    # Add the lock icon to the center of the bing image
    convert $TMPBG-bing4k.png $ICON -gravity center -composite -matte -format PNG $TMPBG-4k.png
    convert $TMPBG-bing150.png $ICON -gravity center -composite -matte -format PNG $TMPBG-150.png
fi

size=$( xrandr | grep \* | sort -r | awk {'print $1; exit'})
# if conneceted to 4k monitor
if [ "$size" == "3840x2160" ];
# Start i3lock with black color, disable mouse and set the created image
then
    i3lock -c 000000 -e -i $TMPBG-4k.png
else
    i3lock -c 000000 -e -i $TMPBG-150.png
fi

# To give some time to i3lock to load the image before suspend happen
#sleep 0.2
