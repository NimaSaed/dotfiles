
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

# 1password
source ~/.config/op/plugins.sh

# oh my posh
#eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/oh-my-posh.toml)"
#eval "$(oh-my-posh init -s bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json')"


eval "$(fzf --bash)"
# Preview file content using bat (https://github.com/sharkdp/bat)

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.terraform
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -L 2 -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig +short {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

export BAT_THEME="Solarized (light)"

if [ "$(uname)" = "Darwin" ];
then
    eval $(gdircolors -b ~/.dircolors/dircolors)
else
    export TERM="screen-256color"
    export TERMINAL="st"
    export TERMCMD="st"
    export RUBYOPT="-W0"
    export BROWSER="firefox"
    eval $(dircolors -b ~/.dircolors/dircolors)
fi

function git_branch() {
    if [ ! -z "$(git branch 2>/dev/null | grep ^*)" ];
    then
        echo -n "$(git branch 2>/dev/null | grep ^* | colrm 1 2)"
        #echo -n " "
        #changes="$(git status -s | grep '^ M' | wc -l | awk '{print $1}')"
        #echo -n "${changes:-0}M "
        #untracked="$(git status -s | grep '^??' | wc -l | awk '{print $1}')"
        #echo -n "${untracked:-0}? "
        #stash="$(git status --show-stash | grep -E "Your stash currently has [0-9]{1,} entr(y|ies)" | grep -Eo '[0-9]{1,}')"
        #echo -n "${stash:-0}S"
    fi
}

function get_aws_profile {
    if [ ! -z "$AWS_PROFILE" ];
    then
        echo "(${AWS_PROFILE}[${AWS_REGION}])";
    fi
}


#PS1="\[\e[1;49;39m\]>_ "
PS1="\n"
PS1+="\[\e[0;49;36m\]\[\e[0;49;96m\]\w\[\e[0;49;36m\] "
PS1+="\[\e[0;49;33m\]\$(git_branch) "
PS1+="\[\e[7;49;93m\]\$(get_aws_profile)"
PS1+="\[\e[0;49;39m\]" #\n"
PS1+="\[\e[1;49;39m\]>_\[\e[0;49;39m\] "

PS2=">> "

# History Setting
HISTSIZE=10000000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%d/%m/%y %T "
# To make C-s work with C-r (serach command) I need to disable stop in stty
stty stop undef

# List directory contents
if [ "$(uname)" = "Darwin" ];
then
    alias ls='gls --color=auto'
else
    alias ls='ls --color=auto'
fi

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

# to put on system clipboard
alias xclip='xclip -selection c'

alias p="python"
alias ruby="ruby"
# alias msfconsole="msfconsole -q"
msf_path="${HOME}/Dropbox/Projects/dockers/msf/docker-compose.yml"
alias msf="docker-compose -f ${msf_path} up --detach"
alias msf2="docker-compose -f ${msf_path} up --scale msf=2 --detach"
alias msf3="docker-compose -f ${msf_path} up --scale msf=3 --detach"
alias msfcon="docker attach msf-msf-1"
alias msfcon2="docker attach msf-msf-2"
alias msfcon3="docker attach msf-msf-3"
alias msfstop="docker-compose -f ${msf_path} stop"
alias msfdown="docker-compose -f ${msf_path} down"

# cat with line number
alias cat='bat'
alias ccat='cat -n'

# add docker host for windows docker and WSL
# export DOCKER_HOST=tcp://0.0.0.0:2375

#Default editor
export EDITOR=vim
export VISUAL=vim
export LC_ALL='en_US.UTF-8'

export LESS=-R
export LESS_TERMCAP_mb=$'\E[4;49;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;49;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # reset bold/blink
export LESS_TERMCAP_so=$'\E[7;49;35m'     # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'           # reset reverse video
export LESS_TERMCAP_us=$'\E[4;49;34m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'           # reset underline

if [ -z "$TMUX" ]; then
    tmux new -t Main
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
    curl -SH "Accept-Language: ${LANG%_*}" --compressed "$request"
}

alias docker=podman

alias arch="docker run --rm -it archlinux/base"
alias barch="docker run --rm -it blackarch bash"

function sslscan(){
    docker run --rm -e URL=${1:-localhost} -e PORT=${2:-443} nimasaed/sslscan;
}

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
function dockerpwshhere() {
    dirname=${PWD##*/}
    docker run --rm -it -v `pwd`:/${dirname} -w /${dirname} mcr.microsoft.com/powershell
}
function webgoat(){
    docker run --rm -p 8080:8080 -p 9090:9090 -e TZ=Europe/Amsterdam --name webgoat webgoat/goatandwolf
}


alias nginxservehere='docker run --rm -it -p 80:80 -p 443:443 -v "$(pwd):/srv/data" nimasaed/nginxserve'

#function trufflehog() {
    #docker run --rm -it trufflesecurity/trufflehog:latest git ${1}
#}

function public_ip() {
    #echo "Public IP: $(curl -s ifconfig.co)"
    public_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
    echo -n $public_ip
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

# AWS
function aws_profile() {

    local aws_home="$HOME/.aws"

    local profiles=(`\
        cat ${aws_home}/config | \
        grep "\[profile" | \
        sed 's/\[//g;s/\]//g' | \
        cut -d " " -f 2`);

    PS3="Select a profile: [none = 0] "

    select profile in ${profiles[@]}
    do
        selected=$profile;
        break;
    done

    unset $PS3;
    if [ ! -z ${profile} ];
    then
        export AWS_PROFILE="${profile}";
        export AWS_REGION=$(cat ${aws_home}/config | sed -n "/${profile}/,/\[/p" | grep region | cut -d '=' -f 2 | sed 's/ //g')
        export AWS_DEFAULT_REGION=$(cat ${aws_home}/config | sed -n "/${profile}/,/\[/p" | grep region | cut -d '=' -f 2 | sed 's/ //g')
        export AWS_ACCESS_KEY_ID=$(cat ${aws_home}/credentials | sed -n "/${profile}/,/\[/p" | grep aws_access_key_id | cut -d '=' -f 2 | sed 's/ //g')
        export AWS_SECRET_ACCESS_KEY=$(cat ${aws_home}/credentials | sed -n "/${profile}/,/\[/p" | grep aws_secret_access_key | cut -d '=' -f 2 | sed 's/ //g')
    else
        export AWS_PROFILE=""
        export AWS_REGION=""
        export AWS_ACCESS_KEY_ID=""
        export AWS_SECRET_ACCESS_KEY=""
        export AWS_SESSION_TOKEN=""
        export AWS_ROLE_ARN=""
    fi
}

function aws_mfa () {

    aws_profile

    read -s -p "AWS MFA: " MFA

    aws_user=$(aws iam get-user | jq .User.UserName -r)
    mfa_arn=$(aws iam list-mfa-devices --user-name $aws_user | jq .MFADevices[0].SerialNumber -r)
    json=$(aws sts get-session-token --serial-number $mfa_arn --token-code $MFA)

    export AWS_SECRET_ACCESS_KEY=$( echo $json | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$( echo $json | jq -r .Credentials.SessionToken)
    export AWS_ACCESS_KEY_ID=$( echo $json | jq -r .Credentials.AccessKeyId)

    aws_admin_role=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName=="admin") | .Arn')

    json=$(aws sts assume-role --role-arn $aws_admin_role --role-session-name admin)

    export AWS_SECRET_ACCESS_KEY=$( echo $json | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$( echo $json | jq -r .Credentials.SessionToken)
    export AWS_ACCESS_KEY_ID=$( echo $json | jq -r .Credentials.AccessKeyId)
    export AWS_ROLE_ARN=$aws_admin_role

}

function aws_region(){

    aws_regions=($(aws ec2 describe-regions --all-regions --query "Regions[].{Name:RegionName}" --output text));

    PS3="Select a region: [none = 0] "

    select region in ${aws_regions[@]}
    do
        selected=$region;
        break;
    done

    unset $PS3;
    if [ ! -z ${region} ];
    then
        export AWS_REGION="$selected";
    else
        aws_profile
    fi
}

function SetProxy(){

    location=${2:-"localhost:8080"}
    if [ "${1:-set}" = "set" ];
    then
        echo "Setting http and https proxy to $location"
        export HTTP_PROXY=http://${location}
        export HTTPS_PROXY=http://${location}
        export all_proxy=http://${location}
    elif [ "${1:-set}" = "unset" ];
    then
        echo "Unsetting http and https proxy"
        unset -v HTTP_PROXY
        unset -v HTTPS_PROXY
        unset -v all_proxy
    fi
}


function vmssh(){

    # get all vm on parallels and make an array
    all_vm=($(prlctl list -a | sed -E 's|([a-zA-Z0-9]) ([a-zA-Z0-9])|\1_\2|g' | sed 1d | awk '{print $1,$2,$4}' | sed 's/ /,/g' | sed 's/[{}]//g'))

    PS3="Select a VM: [none = 0] "

    select vm in ${all_vm[@]}
    do
        selected=$vm;
        break;
    done

    unset $PS3;

    if [ ! -z ${vm} ];
    then
        # get vm details from selected vm
        vm_info=($(echo $vm | sed 's/,/ /g'))
        vm_uuid=${vm_info[0]}
        vm_status=${vm_info[1]}
        vm_name=${vm_info[2]}

        # Start the vm if it is paused, stopped or suspended
        if [ $vm_status = "paused" ] \
            || [ $vm_status = "stopped" ] \
            || [ $vm_status = "suspended" ];
                then
                    prlctl start $vm_uuid
        fi

        # wait for the vm to be available
        while [ $vm_status != "running" ]
        do
            echo $vm_info $vm_uuid $vm_status $vm_name
            vm_status="$(prlctl status $vm_uuid | cut -d " " -f 4)"
        done

        # start ssh service on vm
        prlctl exec $vm_uuid systemctl start ssh

        # creat authorized key in vm for ssh
        sshkey=$(cat ~/.ssh/id_ed25519.pub)
        prlctl exec $vm_uuid "if [ -d \"/home/parallels/.ssh\" ]; then echo \"$sshkey\" > /home/parallels/.ssh/authorized_keys; else mkdir /home/parallels/.ssh; echo \"$sshkey\" > /home/parallels/.ssh/authorized_keys; fi; chown parallels:parallels -R /home/parallels/.ssh"

        # get vm ip address
        #vm_ip=$(prlctl exec $vm_uuid \
        #        ip addr show eth0 | \
        #        grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
        #        grep -v 255)
        vm_ip=$(prlctl list -f $vm_uuid | \
                grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

        if [ ! -z $vm_ip ];
        then
            ssh parallels@${vm_ip}
        else
            echo "no IP is available"
        fi
    fi
}
