#! /bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install curl wget -y
timedatectl set-local-rtc 1

## Chinese input
sudo apt-get install ibus-libpinyin -y
ibus-daemon -d -x -r

## Common tools
sudo apt-get install libopencv-dev libsuitesparse-dev libeigen3-dev cmake python git libboost-all-dev zip unzip make gcc g++ wget build-essential vlc libgoogle-glog-dev libfmt-dev -y
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

## Install Nvidia Driver:
# Select "Using NVIDIA driver metapackage from nvidia-driver-535(proprietary)"
# This maybe working
sudo apt install nvidia-driver-535 -y

## Install VSCode
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code -y

## Install wechat
cd ~/Downloads
wget http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.4_amd64.deb
sudo dpkg -i weixin*.deb