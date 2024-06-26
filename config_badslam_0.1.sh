sudo apt update -y
sudo apt upgrade -y
sudo apt-get install libopencv-dev libsuitesparse-dev libglew-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential qt5-default qtcreator libqt5x11extras5-dev -y

# RealSense
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt-get install librealsense2-dkms -y
sudo apt-get install librealsense2-utils -y
sudo apt-get install librealsense2-dev -y
sudo apt-get install librealsense2-dbg -y

cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build
cmake ..
make -j8
sudo make install

cd ~
sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
mkdir build
cd build
cmake ..
make -j8
sudo make install

cd ~
git clone https://github.com/laurentkneip/opengv
cd opengv
mkdir build && cd build && cmake .. && make -j12
sudo make install

cd ~/Downloads/badslam_without_loop_detector
mkdir build_RelWithDebInfo && cd build_RelWithDebInfo 
cmake  -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CUDA_FLAGS="-arch=sm_75" .. 
