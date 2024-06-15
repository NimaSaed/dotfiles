#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

start_date=$(date +%s)
end_date=$(date +%s --date "${1}")


if [ ${start_date} -gt ${end_date} ]; then
    answer=$((( ${start_date} - ${end_date})/(3600*24)))
else
    answer=$((( ${end_date} - ${start_date} )/(3600*24)))
fi

echo ${answer}

