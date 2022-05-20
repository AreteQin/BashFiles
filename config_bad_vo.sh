sudo apt-get install libopencv-dev libsuitesparse-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential -y

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
make -j12
sudo make install

cd ~
git clone https://github.com/laurentkneip/opengv
cd opengv
mkdir build && cd build && cmake .. && make -j12
sudo make install

cd ~
sudo apt install liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev -y
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
mkdir build
cd build
cmake ..
make -j12
sudo make install

cd ~
sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
mkdir build
cd build
cmake ..
make -j12
sudo make install

# Install ROS
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' 

sudo apt install curl -y # if you haven't already installed curl 

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - 

sudo apt update -y

sudo apt install ros-noetic-desktop-full -y

## To automatically configurate ROS environment while opening a new terminal 

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc 

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 

echo "#export ROS_IP=192.168.99.120" >> ~/.bashrc 

echo "#export ROS_MASTER_URI=http://192.168.99.107:11311" >> ~/.bashrc 

source ~/.bashrc 

sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

sudo apt update -y

sudo apt-get install python3-catkin-tools python3-vcstool python3-osrf-pycommon -y

sudo apt install ros-noetic-octomap-ros ros-noetic-octomap-server ros-noetic-octomap-rviz-plugins -y

sudo rosdep init && rosdep update

source ~/.bashrc 

mkdir -p ~/catkin_ws/src  

cd ~/catkin_ws/src 

catkin_init_workspace 

cd .. 

catkin build 

source devel/setup.bash

sudo apt install ros-noetic-octomap-ros ros-noetic-octomap-server ros-noetic-octomap-rviz-plugins -y