cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build
cmake ..
make -j12
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
cd ~
sudo apt install python3-pip libeigen3-dev -y
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin 
# Install dependencies (as described above, or your preferred method)
./scripts/install_prerequisites.sh recommended
# Configure and build
mkdir build && cd build
cmake ..
cmake --build .
# GIVEME THE PYTHON STUFF!!!! (Check the output to verify selected python version)
cmake --build . -t pypangolin_pip_install
sudo apt install liboctomap-dev octovis
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