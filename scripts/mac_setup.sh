#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

dir=$(dirname $(readlink -f "$0"))

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add brew shellenv to zsh to continue the installation
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/test/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"

# install brew packages
cat ${dir}/brew_install_list | grep -v -E '(^#|^$)' | xargs -I {} brew reinstall {}


# add touch id to sudo and tmux
sudo ${dir}/update_sudo.sh

# add vim plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall +qall

# Modify dock behavior

# move it to left
defaults write com.apple.dock orientation left
# turn on auto hide
defaults write com.apple.dock autohide -bool true
# add delay to auto hide
defaults write com.apple.dock autohide-delay -float 1000
# to put it back defaults delete com.apple.dock autohide-delay
# Remove app bouncing
defaults write com.apple.dock no-bouncing -bool TRUE
# restart dock
killall Dock
