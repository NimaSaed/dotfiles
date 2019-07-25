sudo pacman -Syu

sudo pacman -S \
git \
vim \
feh \
rofi \
acpi \
xorg-xinit \
xorg-server \
xorg-xrandr \
ttf-freefont \
ttf-hack \
firefox \
otf-font-awesome \
tmux \
ranger \
python \
python-pip \
bash-completion \
cmatrix \
openssh \
imagemagick \
scrot \
wget \
arc-gtk-theme \
arc-icon-theme \
nautilus \
alsa-utils \
sysstat \
screenfetch \
go \
virtualbox \
python-pyqt5 \
cpupower \
tlp \
vulkan-intel \
libva-intel-driver \
unclutter \
w3m \
qutebrowser \
pandoc \
acpi_call \
ethtool \
smartmontools \
x86_energy_perf_policy \
mupdf \
highlight \
qtile

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -Rf yay

yay -S --nocleanmenu --nodiffmenu \
skypeforlinux-stable-bin \
otf-san-francisco \
urxvt-resize-font-git \
virtualbox-ext-oracle \
dropbox \
dropbox-cli

sudo systemctl enable dhcpcd.service
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
