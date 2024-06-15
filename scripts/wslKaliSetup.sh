cd ~
sudo apt-get update
sudo apt-get install -y \
                        build-essential \
                        python python-dev\
                        python3 \
                        python3-dev \
                        python-pip \
                        python3-pip \
                        libncurses-dev \
                        cmatrix \
                        bash-completion \
                        tmux \
                        ranger \
                        man-db \
                        pandoc \
                        wget
git clone https://github.com/vim/vim.git
cd vim
./configure     --enable-pythoninterp=yes \
                --enable-python3interp=yes \
                --with-python-command=python \
                --with-python3-command=python3
cd src/
make && sudo make install
cd ~
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
sudo -H pip install -U pip
sudo -H pip3 install -U pip
sudo -H pip3 install mkdocs
sudo -H pip3 install mkdocs-material
sudo cp .scripts/makeSlides /usr/bin/
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
sudo cp .scripts/dropbox /usr/bin
