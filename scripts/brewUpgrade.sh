#!/usr/bin/env bash

set -o nounset # Treat unset variables as an error

function color(){
    # $1 the color light colors 31 - 38 dark colors 91 - 97
    # $2 normal:0 bold:1 underline:4 background:7
    # $3 string
    printf "\e[%s;49;%sm %s \e[0m" $2 $1 "$3"

}

function indent() { sed 's/^/    /'; }

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Updating brew database"
echo

brew update 2>&1 | indent

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Database is updated"
echo

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Upgrading Cli packages"
echo


brew upgrade;


color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Cli packages are updated"
echo

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Getting list of brew cask packages installed"
echo

cask_list=$(brew list --cask)

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Upgrading cask packages"
echo

brew upgrade --cask $cask_list 2>&1 | indent

color 32 1 "[*]"
color 34 0 "[$(date +%Y-%m-%d\ @\ %H:%M:%S)]"
color 95 7 "Done"
echo
