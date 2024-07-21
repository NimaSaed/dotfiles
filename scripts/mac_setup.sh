#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install brew packages
cat brew_install_list | grep -v -E '(^#|^$)' | xargs -I {} brew reinstall {}

# git pull dotfiles
#git clone https://github.com/NimaSaed/dotfiles.git .dotfiles

#install dotfiles
#cd .dotfiles
#sudo bash install.sh

# add touch id to sudo and tmux
#sudo update_sudo.sh

# add vim plug

#curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
#    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#
#vim +PlugInstall +qall

