#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

process=${1}
targets=$(ps aux | grep -i ${process} | grep -vP "(grep|${0})" | sed ':a;N;$!ba;s/\n/|/g' )
echo "---- USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
IFS_bk=$IFS
IFS='|'
index=1
for i in $targets;
do
    echo "${index} -- ${i} "
    index=$(( $index + 1 ))
done
echo "$index -- ALL"

read -p ":" selected

if [ ${selected} -eq $index ];
then
    ps aux | grep -i ${process} | grep -vP "(grep|${0})" | awk '{print $2}' | xargs -L1 kill -9
fi
