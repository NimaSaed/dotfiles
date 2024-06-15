#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

# This script is going to add touch id to sudo command, including inside TMUX

echo "NOTICE: you need to install pam-reattach"

#sudo_path="/etc/pam.d/sudo"

sudo_path="/etc/pam.d/sudo_local"
if [ ! -e "$sudo_path" ]; then cp "${sudo_path}.template" "${sudo_path}"; fi

chmod 644 $sudo_path
sed -i -e '2s/^/auth\t   optional\t  \/opt\/homebrew\/lib\/pam\/pam_reattach.so\n/' $sudo_path
sed -i -e '3s/^/auth\t   sufficient\t  pam_tid.so\n/' $sudo_path
chmod 444 $sudo_path
