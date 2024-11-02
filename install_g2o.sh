#! /bin/bash

echo "Have you installed Ceres? (y/n) "
read ceres

case ${ceres} in
    "y")
        cd ~
        sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
        git clone https://github.com/RainerKuemmerle/g2o.git
        cd g2o
        mkdir build
        cd build
        cmake ..
        make -j6
        sudo make install
        echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
        ;;
    "n")
        echo "Please install Ceres first"
        echo "Exiting..."
        exit
        ;;
esac