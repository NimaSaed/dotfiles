#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

vim "$HOME/Dropbox/Notes/$(date '+%Y-%m-%d %H.%M.%S.md')"
