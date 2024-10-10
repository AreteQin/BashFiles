#! /bin/bash

echo "============================================="
echo "Where are located?"
echo "(1) China"
echo "(2) Canada"
read location

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install curl wget -y

# set correct time for dual boot
timedatectl set-local-rtc 1

## Chinese input
sudo apt install ibus-libpinyin -y
ibus-daemon -d -x -r

## Common tools
sudo apt install libopencv-dev libsuitesparse-dev libeigen3-dev cmake python git libboost-all-dev zip unzip make gcc g++ wget build-essential vlc libgoogle-glog-dev libfmt-dev -y

git config --global user.email "qinqiaomeng@outlook.com" && git config --global user.name "qin"

## Install Nvidia Driver:
# Select "Using NVIDIA driver metapackage from nvidia-driver-535(proprietary)"
# This maybe working
sudo apt install nvidia-driver-535 -y

## for Python source
case ${location} in
    "1")
        pip3 config set global.i	ndex-url https://pypi.tuna.tsinghua.edu.cn/simple
        ;;
    "2")
        echo "Done!"
        ;;
esac
