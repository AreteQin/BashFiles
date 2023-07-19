#! /bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install curl wget -y
timedatectl set-local-rtc 1
## Setup edge
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg
## Install edge
sudo apt update
sudo apt install microsoft-edge-stable -y
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code -y
sudo apt-get install ibus-libpinyin -y
ibus-daemon -d -x -r
sudo apt-get install libopencv-dev libsuitesparse-dev libeigen3-dev cmake python git libboost-all-dev zip unzip make gcc g++ wget build-essential vlc libgoogle-glog-dev libfmt-dev -y
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

## Install wechat
cd ~/Downloads
wget http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.4_amd64.deb
sudo dpkg -i weixin*.deb
