#! /bin/bash

codename=$(lsb_release -c | awk '{print $2}')

case $codename in
"impish")
    echo "Ubuntu 22.04 LTS"
    sudo apt install libabsl-dev -y
    exit
    ;;
"focal")
    echo "Ubuntu 20.04 LTS"
    ;;
esac

cd ~
git clone https://github.com/abseil/abseil-cpp.git
cd abseil-cpp
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j2
sudo make install