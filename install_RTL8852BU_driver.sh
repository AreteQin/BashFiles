echo "============================================="
echo "Installing RTL8852BU driver, choose platform"
echo "(1) x86_64"
echo "(2) Jetson Xavier"
read system

case ${system} in
    "1")
        echo "Not available yet."
        echo "exiting..."
        ;;
    "2")
        cd /usr/src/linux-headers-5.10.216-tegra-ubuntu20.04_aarch64/kernel-5.10/arch 
        sudo ln -s ./arm64 ./aarch64
        cd ~
        git clone https://github.com/AreteQin/RTL8852BU.git # For Jetson Xavier Ubuntu 20
        cd RTL8852BU
        make -j4
        sudo make install
        ;;
esac
