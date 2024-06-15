#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error



curl http://www.google.com -s
check=$?

while [ "$check" == "7" ]
do
    curl http://www.google.com -s
    check=$?
    sleep 2

done

notify-send "Internet is connected"

