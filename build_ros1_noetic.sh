echo "============================================="
echo "Note that you may need to use VPN to connect to ROS server, continue? [y/n]"
read continue

case ${continue} in
    "n")
        echo "Exiting..."
        exit
        ;;
esac

sudo apt-get install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential

sudo rosdep init
rosdep update

mkdir ~/ros_catkin
cd ~/ros_catkin

rosinstall_generator desktop --rosdistro noetic --deps --tar > noetic-desktop.rosinstall
mkdir ./src
vcs import --input noetic-desktop.rosinstall ./src

rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic -y

./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

source ~/ros_catkin_ws/install_isolated/setup.bash