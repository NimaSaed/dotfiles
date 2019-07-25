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

# Scripts
ln -sfn ${PWD}/scripts/ ${HOME}/.scripts

# Bash
ln -sfn ${PWD}/bash/.bash_profile  ${HOME}
ln -sfn ${PWD}/bash/.bashrc ${HOME}

# Tmux
ln -sfn ${PWD}/tmux/.tmux.conf  ${HOME}

# Vim
ln -sfn ${PWD}/vim/.vimrc ${HOME}

# X11
ln -sfn ${PWD}/x11/.Xresources ${HOME}
ln -sfn ${PWD}/x11/.xinitrc ${HOME}

ln -sfn ${PWD}/i3/ ${HOME}/.config/
ln -sfn ${PWD}/mpv/ ${HOME}/.config/

# Colors
ln -sfn ${PWD}/colors/ ${HOME}/.colors
ln -sfn ${PWD}/dircolors/ ${HOME}/.dircolors
