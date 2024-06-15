#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

vpn_name=$(ps aux | grep openvpn | grep -v grep | grep -m 1 -Eo '[a-zA-Z]{1,}\.ovpn' | sed -e 's/\.ovpn//g')
tailor=$(ps aux | grep netExtender | grep -v grep | grep -o 247TAILORSTEEL)
tailor=$(ps aux | grep  openfortivpn | grep -v grep | grep -v tmux | grep -o openfortivpn -m 1)

if [ ${vpn_name:-nothing} != "nothing" ]; then
    case ${vpn_name} in
        nima)
            echo "<span color='$(xrdb -query | grep -w color4 | cut -f2)'></span>";;
        masky)
            echo "<span color='$(xrdb -query | grep -w color14 | cut -f2)'></span>";;
        *)
            echo "";;
    esac
elif [ "$tailor" = "openfortivpn" ]; then
        echo "<span color='$(xrdb -query | grep -w color14 | cut -f2)'></span>"
else
    echo "<span color='$(xrdb -query | grep -w color1 | cut -f2)'></span>"
fi


