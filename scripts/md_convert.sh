#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

filePath="$1"
PageTitle="$(cat "$filePath" | grep -m 1 -E '^# ' | sed 's/#//g')"
outfile="$(echo "$filePath" | grep -Eo '[ a-zA-Z0-9\_\.\-]{1,}$' | cut -d. -f 1)"
toc="--toc"
themePath="$HOME/Dropbox/Notes/.resources/github.css"

pandoc -c "${themePath}" -s "${filePath}" -o "$PWD/${outfile}.html" --metadata pagetitle="${2:-$PageTitle}" --embed-resources --standalone ${toc} --filter mermaid-filter

echo "$PWD/${outfile}.html"
