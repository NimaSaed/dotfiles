#
# ~/.bash_profile
#
export BASH_SILENCE_DEPRECATION_WARNING=1
PATH="${HOME}/.scripts/:${PATH}"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# bash completion
[[ -r "$(brew --prefix)/etc/bash_completion.d/brew" ]] && . "$(brew --prefix)/etc/bash_completion.d/brew"
[[ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]] && . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
#[[ -r "$(brew --prefix)/etc/bash_completion.d/" ]] && . "$(brew --prefix)/etc/bash_completion.d/"

# 1password
source /Users/nima/.config/op/plugins.sh
source <(op completion bash)

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)
