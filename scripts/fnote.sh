#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

word="${1:-''}"

# Change IFS
#savedIFS=$IFS
#IFS=$'\n'

if [ -n "$word" ];
then

    IFS=$'\n', list=($(grep --color=auto -nirw --include \*.md ~/Dropbox/Notes -e "$word"))
    if [ ${list:-''} == "" ];
    then
        echo "Nothing has found";
        exit 0;
    fi
fi

for n in ${!list[@]}
do
    echo [$n]- ${list[$n]}
done

read selected

selectedPath=$(echo ${list[$selected]} | cut -d: -f1)

if [ "$(uname)" == "Darwin" ];
then
    clipboard="pbcopy";
else
    clipboard="xclip -selection c";
fi
echo -n "\"$selectedPath\"" | $clipboard

# Change back IFS
#IFS=$savedIFS

vim "$selectedPath"
exit 0
