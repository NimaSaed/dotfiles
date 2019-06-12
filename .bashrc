#export TERM="screen-256color"
export TERMINAL="st"

#PS1='\e[0;33m(\u) >_ \e[0;33m(\W)\e[0m '
PS1='\e[0;33m >_ \e[0;33m(\W)\e[0m '
eval $(dircolors ~/.dircolors/dircolors)

# History Setting
HISTSIZE=10000000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%d/%m/%y %T "
# To make C-s work with C-r (serach command) I need to disable stop in stty
stty stop undef

# List directory contents
alias ls='ls --color=auto'
alias sl=ls
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -hl'
alias l='ls -a'
alias l1='ls -1'
alias lst='ls -R | grep ":$" | sed -e '"'"'s/:$//'"'"' -e '"'"'s/[^-][^\/]*\//--/g'"'"' -e '"'"'s/^/   /'"'"' -e '"'"'s/-/|/'"'"

# Shortcuts to edit startup files
alias vbrc="vim ~/.bashrc"
alias vbpf="vim ~/.bash_profile"
alias vrc="vim ~/.vimrc"
alias vi3c="vim ~/.config/i3/config"
alias vi3b="vim ~/.config/i3/i3blocks.conf"

alias _="sudo"
alias c='clear'
alias k='clear'
alias cls='clear'
alias q='exit'

alias ..='cd ..'         # Go up one directory
alias cd..='cd ..'       # Common misspelling for going up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -' # Go back
alias ~='cd ~' # Go Home

# sudo vim
alias svim="sudo vim"

# grep color
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

#other
alias rg='ranger'
alias standby='cmatrix -aC green -b -u 6'
alias x='startx'

# to put on system clipboard
alias xclip='xclip -selection c'
alias p="python"
alias pacman="sudo pacman"

# add docker host for windows docker and WSL
# export DOCKER_HOST=tcp://0.0.0.0:2375

#Default editor
export EDITOR='vim'
export LC_ALL='en_US.UTF-8'

#Man page color
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
#export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

if [ -z "$TMUX" ]; then 
    tmux a -t Main || tmux new -s Main
fi

export n=~/Dropbox/Notes/
alias en="cd $n && vim note_index.md && cd"
alias gn="cd $n"
alias sn="tree $n"
alias n="~/.scripts/createNote.sh"
alias t="~/.scripts/todo"

wttr()
{
    local request="wttr.in/${1-3.108861, 101.580861}?0"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}
