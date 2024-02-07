#! /bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install curl wget -y

# set correct time for dual boot
timedatectl set-local-rtc 1

## Chinese input
sudo apt-get install ibus-libpinyin -y
ibus-daemon -d -x -r

## Common tools
sudo apt-get install libopencv-dev libsuitesparse-dev libeigen3-dev cmake python git libboost-all-dev zip unzip make gcc g++ wget build-essential vlc libgoogle-glog-dev libfmt-dev -y
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

git config --global user.email "qinqiaomeng@outlook.com"
git config --global user.name "qin"

## Install Nvidia Driver:
# Select "Using NVIDIA driver metapackage from nvidia-driver-535(proprietary)"
# This maybe working
sudo apt install nvidia-driver-535 -y