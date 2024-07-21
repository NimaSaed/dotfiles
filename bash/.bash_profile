# if macos, add brew shellenv
if [ "$(uname)" = "Darwin" ];
then
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
	export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
	export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi
export PATH="${HOME}/.scripts/:${PATH}"

# bash completion
[[ -r "$(brew --prefix)/etc/bash_completion.d/brew" ]] && . "$(brew --prefix)/etc/bash_completion.d/brew"
[[ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]] && . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
#[[ -r "$(brew --prefix)/etc/bash_completion.d/" ]] && . "$(brew --prefix)/etc/bash_completion.d/"

source <(op completion bash)

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)
