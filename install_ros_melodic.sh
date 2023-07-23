sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt install curl -y # if you haven't already installed curl 

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update -y

sudo apt install ros-melodic-desktop-full -y

## To automatically configurate ROS environment while opening a new terminal 

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 

echo "#export ROS_IP=192.168.99.120" >> ~/.bashrc 

echo "#export ROS_MASTER_URI=http://192.168.99.107:11311" >> ~/.bashrc 

source ~/.bashrc 

sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y

## For catkin build
sudo apt-get install ros-melodic-catkin python-catkin-tools

sudo apt install python-rosdep

sudo rosdep init

rosdep update