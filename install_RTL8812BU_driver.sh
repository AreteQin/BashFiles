echo "============================================="
echo "Installing RTL8812BU driver, choose platform"
echo "(1) x86_64"
echo "(2) Jetson Xavier"
read system

sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential dkms git bc make gcc

cd ~ 

case ${system} in
    "1")
        #git clone -b v5.13.1 https://github.com/fastoe/RTL8812BU.git # For x86_64 Ubuntu20
        git clone git@github.com:morrownr/88x2bu-20210702.git
        cd 88x2bu-20210702/
        sudo ./install-driver.sh
        ;;
    "2")
        git clone -b v5.6.1 https://github.com/fastoe/RTL8812BU.git # For Jetson Xavier Ubuntu 20
        cd RTL8812BU
        make -j2
        sudo make install
        ;;
esac

#wget deb.trendtechcn.com/install -O ./install.sh && sh ./install.sh'