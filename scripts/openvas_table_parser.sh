#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

file_path=$1

echo "||IP||Date||"
#cat ${file_path} | \
#    grep -oP '<host>[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|<creation_time>(.)*</creation_time>' | \
#    sed 's/<host>//g' | \
#    sed 's/<creation_time>//g' | \
#    sed 's/<\/creation_time>//g' | \
#    sed -z 's/:00\n/ /g' | \
#    awk '{print $2 " " $1}' | \
#    sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 -u | \
#    sed 's/^/|/g' | \
#    sed 's/$/|/g' | \
#    sed 's/ /|/g'

num=$(xq .get_results_response.result_count.filtered ${file_path} | sed 's/"//g')

list=$(for i in $(seq 0 $(( $num - 1)) ); do
    echo -n "$(xq .get_results_response.result[$i].host $file_path | grep -oP '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')|"
    echo "$(xq .get_results_response.result[$i].creation_time $file_path | sed 's/"//g')"
done)
list=$(echo $list | sed 's/ /\\n/g')
echo -e $list | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 -u | sed 's/^/|/g' | sed 's/$/|/g'
