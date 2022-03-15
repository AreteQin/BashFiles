sudo apt update -y
sudo apt upgrade -y
sudo apt-get install libopencv-dev libsuitesparse-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake qt5-default qtcreator libqt5x11extras5-dev libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential -y

sudo apt-get install ros-noetic-realsense2-camera -y

unzip DLib-master.zip
cd DLib-master
mkdir build
cd build
cmake .. 
make -j8
sudo make install
cd ..
cd ..

unzip g2o-master.zip
cd g2o-master
mkdir build
cd build
cmake .. 
make -j8
sudo make install
cd ..
cd ..

unzip opengv-master.zip
cd opengv-master
mkdir build
cd build
cmake .. 
make -j8
sudo make install
cd ..
cd ..

tar -xvzf zlib-1.2.11.tar.gz 
cd zlib-1.2.11
mkdir build
cd build
cmake .. 
make -j8
sudo make install
cd ..
cd ..

tar -xvzf badslam-1.1.0.tar.gz
cd badslam-1.1.0
cd opengv-master
mkdir build_RelWithDebInfo && cd build_RelWithDebInfo 
cmake  -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CUDA_FLAGS="-arch=sm_75" .. 
