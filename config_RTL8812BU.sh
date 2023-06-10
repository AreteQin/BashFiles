sudo apt update
sudo apt install -y build-essential dkms git bc
git clone -b v5.13.1 https://github.com/fastoe/RTL8812BU.git
cd RTL8812BU
make
sudo make install

#wget deb.trendtechcn.com/install -O ./install.sh && sh ./install.sh'