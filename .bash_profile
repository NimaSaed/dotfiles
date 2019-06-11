#
# ~/.bash_profile
#
PATH="$PATH:~/.scripts"
export PATH

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
