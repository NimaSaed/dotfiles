#!/usr/bin/env bash
set -oe nounset # Treat unset variables as an error

trap '
    resolvconf -d tun0 2> /dev/null
    ' EXIT

vpn_name="${1:-nima}"

if [ $(id -u) = 0 ]; then
    resolvconf -a tun0 < <(echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8");
    openvpn --verb 3 --config Dropbox/Arch\ Linux/${vpn_name}.ovpn \
       || (echo "Cannot connect to ${vpn_name}"; find $PWD -name *.ovpn; exit 1;);
else
   echo "You need to run this with sudo"
fi
exit 0
