username=$(id -u --name)
dir=$(dirname $(dirname $(readlink -f "$0")))

sudo pacman -Syu

sudo pacman -S \
base-devel \
wpa_supplicant \
git \
i3-wm \
i3blocks \
i3lock \
gvim \
feh \
acpi \
xorg-xinit \
xorg-server \
xorg-xrandr \
xorg-xbacklight \
xorg-xinput \
xclip \
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
vagrant \
libva-intel-driver

curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ${HOME}
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

sudo cp ${dir}/i3/lock.service /etc/systemd/system/
sudo systemctl enable lock.service

sudo cp ${dir}/wifi/wpa_supplicant.service /etc/systemd/system/
sudo systemctl enable wpa_supplicant.service

sudo sed -i 's/dockerd -H/dockerd --data-root=\/home\/.docker -H/g' /usr/lib/systemd/system/docker.service
sudo systemctl enable docker

sudo usermod -a -G wheel,docker,vboxusers ${username}

git clone https://git.suckless.org/st st-git
patch -d st-git/ -p1 < ${dir}/st/st-x11Hack-20190730-f484d74.diff
sudo make -C st-git/ install
rm -rf st-git
