echo "============================================="
echo "Installing RTL8812BU driver, choose platform"
echo "(1) x86_64"
echo "(2) iCrest2"
read system

sudo apt update
sudo apt install -y build-essential dkms git bc make gcc

case &system in
    "1")
        git clone -b v5.13.1 https://github.com/fastoe/RTL8812BU.git # For x86_64 Ubuntu20
        ;;
    "2")
        git clone -b v5.6.1 https://github.com/fastoe/RTL8812BU.git # For iCrest 2 Ubuntu 20
        ;;
esac
cd RTL8812BU
make -j4
sudo make install

#wget deb.trendtechcn.com/install -O ./install.sh && sh ./install.sh'