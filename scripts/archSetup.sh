sudo pacman -Syu

sudo pacman -S \
git \
i3-wm \
i3blocks \
i3lock \
vim \
feh \
acpi \
xorg-xinit \
xorg-server \
xorg-xrandr \
xorg-xbacklight \
ttf-hack \
firefox \
otf-font-awesome \
tmux \
vifm \
bash-completion \
openssh \
imagemagick \
scrot \
wget \
alsa-utils \
sysstat \
screenfetch \
go \
virtualbox \
cpupower \
tlp \
unclutter \
mupdf \
highlight \
hsetroot \
mpv \
dmenu \
pacman-contrib \
mesa \
vulkan-intel \
xf86-video-intel \
docker \
docker-compose \
libva-intel-driver

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -Rf yay

yay -S --nocleanmenu --nodiffmenu \
skypeforlinux-stable-bin \
virtualbox-ext-oracle \
dropbox \
dropbox-cli

sudo systemctl enable dhcpcd.service
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

sudo cp ../i3/lock.service /etc/systemd/system/
sudo systemctl enable lock.service

sudo cp ../wifi/wpa_supplicant.service /etc/systemd/system/
sudo systemctl enable wpa_supplicant.service

sudo sed -i 's/dockerd -H/dockerd --data-root=\/home\/.docker -H/g' /usr/lib/systemd/system/docker.service
sudo systemctl enable docker

sudo usermod -a -G wheel,docker,vboxusers nima
