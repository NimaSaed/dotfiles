#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Updating brew database: ";
brew update
echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Database is updated";
echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Upgrading Cli packages";
brew upgrade;
echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Cli packages are updated";

echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Getting list of brew cask packages installed"
cask_list=$(brew list --cask)

echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Upgrading cask packages"
brew upgrade --cask $cask_list

echo "[*] [$(date +%Y-%m-%d\ @\ %H:%M:%S)] Done"
