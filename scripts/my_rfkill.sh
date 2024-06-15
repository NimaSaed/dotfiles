#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

status=$(rfkill --raw -n | grep wlan | awk '{print $4}' | sed 's/ed$//')


case $status in
    block)
        # unblock the wifi
        rfkill unblock wlan
        ;;
    unblock)
        # block the wifi
        rfkill block wlan
esac

exit 0
