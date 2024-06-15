#
# ~/.bash_profile
#
export BASH_SILENCE_DEPRECATION_WARNING=1
PATH="${HOME}/.scripts/:${PATH}"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# bash completion
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# 1password
source /Users/nima/.config/op/plugins.sh
source <(op completion bash)

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)
