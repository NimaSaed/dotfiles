#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

host=${1}
username="kali"

read -s -p "$username@$host's password: " password

local_port=$(shuf -i 25555-26000 -n 1)

ssh -f -L $local_port:localhost:3389 $username@$host sleep 1
xfreerdp /v:localhost:$local_port /u:$username /p:"$password" /f /dynamic-resolution
