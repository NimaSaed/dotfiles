#
# ~/.bash_profile
#
#export BASH_SILENCE_DEPRECATION_WARNING=1
#PATH="${HOME}/.scripts/:${PATH}"
#PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
#export PATH="/opt/homebrew/bin:$PATH"
#export PATH="/opt/homebrew/sbin:$PATH"
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
# bash completion
[[ -r "$(brew --prefix)/etc/bash_completion.d/brew" ]] && . "$(brew --prefix)/etc/bash_completion.d/brew"
[[ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]] && . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
#[[ -r "$(brew --prefix)/etc/bash_completion.d/" ]] && . "$(brew --prefix)/etc/bash_completion.d/"

source <(op completion bash)

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)
