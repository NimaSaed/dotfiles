username=$(id -u --name)
dir=$(dirname $(dirname $(readlink -f "$0")))

sudo pacman -Syu

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ${dir}/scripts/
rm -rf yay

yay -S --nocleanmenu --nodiffmenu --noremovemake \
teams \
virtualbox-ext-oracle \
dropbox \
dropbox-cli \
vim-youcompleteme-git \
vim-plug

vim +PlugInstall +qall

sudo systemctl enable --now dhcpcd.service

sudo systemctl enable --now ntpd

#iptable

sudo cp ${dir}/iptable/ip* /etc/iptables/
sudo systemctl enable --now iptables.service
sudo systemctl enable --now ip6tables.service

#sudo systemctl enable tlp.service
#sudo systemctl enable tlp-sleep.service
#sudo systemctl mask systemd-rfkill.service
#sudo systemctl mask systemd-rfkill.socket

sudo cp ${dir}/i3/lock.service /etc/systemd/system/
sudo systemctl enable --now lock.service

sudo cp ${dir}/wifi/wpa_supplicant.service /etc/systemd/system/
sudo systemctl enable --now wpa_supplicant.service

sudo systemctl enable --now docker

sudo usermod -a -G wheel,docker,vboxusers,video ${username}

git clone https://git.suckless.org/st st-git
patch -d st-git/ -p1 < ${dir}/st/st-x11Hack-20190730-f484d74.diff
sudo make -C st-git/ install
rm -rf st-git

# To fix the firefox gpu problem
echo -en "Section \"OutputClass\"\n  Identifier \"Intel Graphics\"\n  MatchDriver \"i915\"\n  Driver \"intel\"\n  Option \"TearFree\" \"true\"\n  Option \"NoAccel\" \"False\"\n  Option \"DRI\" \"False\"\nEndSection" | sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null

# Change pacman setting
sed -e 's/#Color/Color/' -e 's/#TotalDownload/TotalDownload/' -e 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf > /tmp/pacman.conf
sudo cp /tmp/pacman.conf /etc/pacman.conf
