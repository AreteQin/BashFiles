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

echo "Have you installed Nvidia driver? (y/n)"
read driver
if [ ${driver} != "y" ]; then
    echo "============================================="
    echo "Installing Nvidia driver..."
    if [ ${codename} == "focal" ]; then
        sudo apt install nvidia-driver-535 -y
    else
        sudo apt install nvidia-driver-535 -y
    fi
    echo "============================================="
    echo "Nvidia driver is installed!"
    echo "Press any key to reboot your computer to enable the driver and run this script again."
    read -n 1 -s
    sudo reboot
fi

echo "============================================="
echo "Where are you located?"
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
echo "Install MicroSoft Edge? (y/n)"
read edge

echo "============================================="
echo "Install VSCode? (y/n)"
read vscode

echo "============================================="
echo "Install Clion? (y/n)"
read clion

echo "============================================="
echo "Configure Git user name and email? (y/n)"
read git

echo "============================================="
echo "Configure cloudflare? (y/n)"
read cloudflare

echo "============================================="
echo "Enable RDP? (y/n)"
read rdp

echo "============================================="
echo "Enable VNC? (y/n)"
read vnc

echo "============================================="
echo "Install Tailscale? (y/n)"
read tailscale

echo "============================================="
echo "Install Office? (y/n)"
read office

echo "============================================="
echo "Install CUDA? (y/n)"
read cuda

echo "============================================="
echo "Install QT5? (y/n)"
read qt5

echo "============================================="
echo "Install LaTex? (y/n)"
read latex

echo "============================================="
echo "Install Docker? (y/n)"
read docker

echo "============================================="
echo "Install ollama? (y/n)"
read ollama

echo "============================================="
echo "Install Anaconda? (y/n)"
read anaconda

echo "============================================="
echo "Install MeshLab? (y/n)"
read meshlab

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

sudo apt install curl wget libopencv-dev libsuitesparse-dev libeigen3-dev cmake git libboost-all-dev zip unzip make gcc g++ vlc libgoogle-glog-dev libfmt-dev build-essential vim remmina -y

# set correct time for dual boot
timedatectl set-local-rtc 1

cd ~/Downloads/BashFiles/

## Chinese input
if [ ${cn_input} == "y" ]; then
    sudo apt install ibus-libpinyin -y
    ibus-daemon -d -x -r
fi

## for VPN Proxy
case ${location} in
"1")
    echo "============================================="
    echo "Location is China. Installing Clash Verge..."
    
    # Download and install a recent release of clash-verge-rev
    wget -qO /tmp/clash-verge.deb https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v1.6.6/clash-verge_1.6.6_amd64.deb
    sudo dpkg -i /tmp/clash-verge.deb
    sudo apt-get install -f -y
    rm /tmp/clash-verge.deb

    echo "============================================="
    echo "Clash Verge installed."
    echo "Please open Clash Verge from your application menu, manually configure your profiles, and turn the system proxy ON."
    
    while true; do
        read -p "Type 'y' and press Enter once you have confirmed Clash Verge is connected and running: " conf_clash
        if [ "${conf_clash}" == "y" ]; then
            echo "Proxy confirmed. Proceeding with the remaining installations..."
            break
        else
            echo "Awaiting confirmation..."
        fi
    done

    # Exporting proxy variables for the current script session to ensure subsequent downloads work
    export HTTP_PROXY="http://127.0.0.1:7897"
    export HTTPS_PROXY="http://127.0.0.1:7897"
    export http_proxy="$HTTP_PROXY"
    export https_proxy="$HTTPS_PROXY"
    export ALL_PROXY="socks5://127.0.0.1:7897"
    export all_proxy="$ALL_PROXY"

    proxy_on() {
        export HTTP_PROXY="http://127.0.0.1:7897"
        export HTTPS_PROXY="http://127.0.0.1:7897"
        export http_proxy="$HTTP_PROXY"
        export https_proxy="$HTTPS_PROXY"

        echo "Proxy enabled: $HTTP_PROXY"
    }

    proxy_off() {
        unset HTTP_PROXY HTTPS_PROXY
        unset http_proxy https_proxy
        unset ALL_PROXY all_proxy

        echo "Proxy disabled"
    }
    ;;
esac

if [ ${chrome} == "y" ]; then
    bash ./install_chrome.sh
fi

if [ ${edge} == "y" ]; then
    bash ./install_edge.sh
fi

if [ ${git} == "y" ]; then
    git config --global user.email "qinqiaomeng@outlook.com" && git config --global user.name "qin"
fi

if [ ${meshlab} == "y" ]; then
    sudo apt install meshlab -y
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

if [ ${tailscale} == "y" ]; then
    curl -fsSL https://tailscale.com/install.sh | sh
fi

## Configure cloudflare:
if [ ${cloudflare} == "y" ]; then
    bash ./install_cloudflare.sh
fi

## Install Office:
if [ ${office} == "y" ]; then
    bash ./install_onlyoffice.sh
fi

## Install Qt5:
if [ ${qt5} == "y" ]; then
    sudo apt install qt5-default libqt5x11extras5-dev libqt5svg5-dev -y
fi

## Enable RDP:
if [ ${rdp} == "y" ]; then
    bash ./enable_rdp.sh
fi

## Install Docker:
if [ ${docker} == "y" ]; then
    bash ./install_docker.sh
fi

## for Python source
case ${location} in
"1")
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    ;;
esac

## Install LaTex:
if [ ${latex} == "y" ]; then
    sudo apt install texlive-full -y
fi

## Install ollama:
if [ ${ollama} == "y" ]; then
    curl -fsSL https://ollama.com/install.sh | sh
    google-chrome https://github.com/ollama/ollama
    echo "============================================="
    echo "please type the ollama version you want to install according to the webpage just opened: "
    read ollama
    ollama pull ${ollama}
fi

## Install Anaconda:
if [ ${anaconda} == "y" ]; then
    bash ./install_anaconda.sh
fi

## Configure VNC:
if [ ${vnc} == "y" ]; then
    bash ./enable_vnc.sh
fi

## Install CUDA:
if [ ${cuda} == "y" ]; then
    bash ./install_cuda.sh
fi

if [ ${tailscale} == "y" ]; then
    sudo tailscale up
    echo "============================================="
    echo "Tailscale installed. Please use the link above to login. "
fi