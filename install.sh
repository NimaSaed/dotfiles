#!/bin/bash -
#===============================================================================
#
#          FILE: install.sh
#
#         USAGE: ./install.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Nima Saed (), nima.saed@me.com
#  ORGANIZATION:
#       CREATED: 06/10/2019 09:34:22 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

#mkdir ${HOME}/.scripts
if [ ! -d "${HOME}/.config" ]; then mkdir ${HOME}/.config; fi
#mkdir ${HOME}/.colors
#mkdir ${HOME}/.dircolors
#mkdir ${HOME}/.vifm
#
# Scripts
ln -sfn "${PWD}/scripts/" "${HOME}/.scripts"

# Bash
ln -sfn "${PWD}/bash/.bash_profile"  ${HOME}
ln -sfn "${PWD}/bash/.bashrc" ${HOME}

# Tmux
ln -sfn "${PWD}/tmux/.tmux.conf"  ${HOME}

# Vim
ln -sfn "${PWD}/vim/.vimrc" ${HOME}

# X11
ln -sfn "${PWD}/x11/.Xresources" ${HOME}
ln -sfn "${PWD}/x11/.xinitrc" ${HOME}

# i3-wm
ln -sfn "${PWD}/i3/" ${HOME}/.config/

# MPV media player
ln -sfn "${PWD}/mpv/" ${HOME}/.config/

# Colors
ln -sfn "${PWD}/colors/" ${HOME}/.colors
ln -sfn "${PWD}/dircolors/" ${HOME}/.dircolors

# vifm (vi file manager)
ln -sfn "${PWD}/vifm/" ${HOME}/.vifm

# git config
ln -sfn "${PWD}/git/.gitconfig" ${HOME}

# alacritty
ln -sfn "${PWD}/alacritty/" ${HOME}/.config/

# amethyst
ln -sfn "${PWD}/amethyst" ${HOME}/.config/

# aerospace
ln -sfn "${PWD}/aerospace" ${HOME}/.config/

# oh-my-posh
ln -sfn "${PWD}/oh-my-posh/" ${HOME}/.config/

# install mac apps if this is a macos
#if [ "$(uname)" = "Darwin" ]; then ./scripts/mac_setup.sh; fi

# Nix Darwin
ln -sfn "${PWD}/nix" ${HOME}/.config/


