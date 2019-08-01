# set -o vi
#export TERM="screen-256color"
export TERMINAL="st"
export TERMCMD="st"

PS1='\[\e[0;49;97m\] >_ \[\e[0;49;36m\](\[\e[0;49;96m\]\W\[\e[0;49;36m\])\[\e[0;49;97m\] '
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

export LESS=-R
export LESS_TERMCAP_mb=$'\E[4;49;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;49;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[7;49;35m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[4;49;34m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

if [ -z "$TMUX" ]; then
    tmux a -t Main || tmux new -s Main
fi

export n=~/Dropbox/Notes/
alias en="cd $n && vim note_index.md && cd"
alias gn="ranger ~/Dropbox/Notes"
alias sn="tree $n"
alias n="~/.scripts/createNote.sh"
alias t="~/.scripts/todo"

wttr()
{
    local request="wttr.in/${1-}?0"
    [ "$COLUMNS" -lt 125 ] && request+='?n'
    curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

alias arch="docker run --rm -it archlinux/base"
alias barch="docker run --rm -it blackarch bash"

# I learn these from https://blog.ropnop.com/docker-for-pentesters/
alias dockerbash="docker run --rm -it --entrypoint=/bin/bash"
alias dockershell="docker run --rm -it --entrypoint=/bin/sh"

function dockerbashhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}

alias nginxservehere='docker run --rm -it -p 80:80 -p 443:443 -v "$(pwd):/srv/data" nimasaed/nginxserve'

function msf() {
    if [ -z "$(docker network ls | grep -w msf)" ];
    then
        docker network create --subnet=172.18.0.0/16 msf
    fi
    if [ -z "$(docker ps -a | grep -w postgres)" ];
    then
        docker run --ip 172.18.0.2 --network msf --rm --name postgres -v "${HOME}/.msf4/database:/var/lib/postgresql/data" -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e POSTGRES_DB=msf -d postgres:11-alpine
    fi
    docker pull metasploitframework/metasploit-framework:latest
    docker run --rm -it --network msf --name msf --ip 172.18.0.3 -e DATABASE_URL='postgres://postgres:postgres@172.18.0.2:5432/msf' -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework
 }

function public_ip() {
    echo "Public IP: $(curl -s ifconfig.co)"
}

function news() {
    curl -s getnews.tech/"$@"
}

function cht() {
    curl -s cht.sh/"$@"
}

function rate() {
    curl -s rate.sx/"$@"
}

function dic() {
    curl -s dict://dict.org/d:"$@"
}

# list users with their login and name (just for educational purpose)
function list_users() {
    while IFS=: read login a b c name e;
    do
        printf "%-30s %s\n" "$login" "$name";
    done < /etc/passwd
}
