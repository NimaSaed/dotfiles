#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

screen_capture_process=$(ps aux | grep -w screen_capture | grep -v grep)
screen_capture_flag=$(echo $screen_capture_process | awk '{print $13}')

if [ -n "$screen_capture_process" ];
then
    case $screen_capture_flag in
        "-w")
            echo "<span color='$(xrdb -query | grep -w color14 | cut -f2)'>   </span>"
            ;;
        "-a")
            echo "<span color='$(xrdb -query | grep -w color14 | cut -f2)'>   </span>"
            ;;
        *)
            echo "<span color='$(xrdb -query | grep -w color14 | cut -f2)'>   </span>"
            ;;
    esac
else
    echo "<span color='$(xrdb -query | grep -w foreground | cut -f2)'>   </span>"
fi
