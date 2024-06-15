#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

ip=$1

nmap -p- -Pn -oG $ip.gnmap $ip

ports=$(cat $ip.gnmap | grep -oP ' [0-9]{1,7}/' | sed 's/\///g')
rm $ip.gnmap
ports=$(echo $ports | sed 's/ /,/g')

nmap -sV $ip -p $ports
