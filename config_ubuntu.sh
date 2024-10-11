#! /bin/bash

codename=$(lsb_release -c | awk '{print $2}')

case $codename in
    "impish")
        echo "Ubuntu 22.04 LTS"
        ;;
    "focal")
        echo "Ubuntu 20.04 LTS"
        ;;
    "*")
        echo "Not supported Ubuntu version!"
        exit
        ;;
esac

echo "============================================="
echo "Where are located?"
echo "(1) China"
echo "(2) Canada"
read location

echo "============================================="
echo "Install Chinese Input Method? (y/n)"
read cn_input

echo "============================================="
echo "Install Google Chrome? (y/n)"
read chrome

echo "============================================="
echo "Install VSCode? (y/n)"
read vscode

echo "============================================="
echo "Install Nvidia Driver 535? (y/n)"
read nvidia

echo "============================================="
echo "Install Clion? (y/n)"
read clion

echo "============================================="
echo "Install WeChat? (y/n)"
read wechat

echo "============================================="
echo "Configure Git user name and email? (y/n)"
read git

echo "============================================="
echo "Configure cloudflare? (y/n)"
read cloudflare

echo "============================================="
echo "Enable VNC? (y/n)"
read vnc

echo "============================================="
echo "Install Tailscale? (y/n)"
read tailscale

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install curl wget libopencv-dev libsuitesparse-dev libeigen3-dev cmake python git libboost-all-dev zip unzip make gcc g++ vlc libgoogle-glog-dev libfmt-dev build-essential -y

# set correct time for dual boot
timedatectl set-local-rtc 1

cd ~/Downloads/BashFiles/

## Chinese input
if [ ${cn_input} == "y" ]; then
    sudo apt install ibus-libpinyin -y
    ibus-daemon -d -x -r
fi

if [ ${chrome} == "y" ]; then
    bash ./install_chrome.sh
fi

## Configure VNC:
if [ ${vnc} == "y" ]; then
    bash ./enable_vnc.sh
fi

if [ ${git} == "y" ]; then
    git config --global user.email "qinqiaomeng@outlook.com" && git config --global user.name "qin"
fi

## Install Nvidia Driver:
# Select "Using NVIDIA driver metapackage from nvidia-driver-535(proprietary)"
# This maybe working
if [ ${nvidia} == "y" ]; then
    sudo apt install nvidia-driver-535 -y
    echo "============================================="
    echo "Nvidia driver is installed!"
fi

## Install VSCode:
if [ ${vscode} == "y" ]; then
    bash ./install_vscode.sh
fi

## Install Clion:
if [ ${clion} == "y" ]; then
    sudo snap install clion --classic
    echo "============================================="
    echo "CLion installed!"
fi

## Install WeChat:
if [ ${wechat} == "y" ]; then
    bash./install_wechat.sh
fi

if [ ${tailscale} == "y" ]; then
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
fi
echo "============================================="
echo "Tailscale installed. Please use the link above to login. "
echo "When done, press any key to continue..."
read -n 1 -s

## Configure cloudflare:
if [ ${cloudflare} == "y" ]; then
    bash ./install_cloudflare.sh
fi

## for Python source
case ${location} in
    "1")
        pip3 config set global.i	ndex-url https://pypi.tuna.tsinghua.edu.cn/simple
        echo "Done!"
        ;;
    "2")
        echo "Done!"
        ;;
esac
