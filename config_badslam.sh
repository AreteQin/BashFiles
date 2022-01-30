sudo apt update -y
sudo apt upgrade -y

sudo apt-get install libsuitesparse-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake qt5-default qtcreator libqt5x11extras5-dev libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential -y

unzip opencv-3.4.6.zip 
unzip opencv_contrib-3.4.6.zip

cd opencv-3.4.6
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=~/Downloads/Ubuntu/opencv_contrib-3.4.6/modules .. 
make -j8
sudo make install
cd ..
cd ..
