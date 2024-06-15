#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

bluetoothctl power on > /dev/null

error=28
sit=700
stand=1130

if [ ${button:-0} -eq 1 ];
then
    idasen-controller --move-to $( echo "${stand}+${error}" | bc ) > /dev/null
elif [ ${button:-0} -eq 3 ];
then
    idasen-controller --move-to $( echo "${sit}+${error}" | bc ) > /dev/null
fi

echo " $(echo "$(idasen-controller | grep ^Height: | awk '{print $2}' | sed 's/mm//g')-${error}" | bc )"
