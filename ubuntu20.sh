sudo apt update -y
sudo apt upgrade -y
sudo apt install nvidia-driver-460 -y
sudo apt install curl -y
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
sudo apt install vim libreoffice texlive-full -y
sudo apt-get install libopencv-dev libsuitesparse-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake qt5-default qtcreator libqt5x11extras5-dev libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential vlc libgoogle-glog-dev -y
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
