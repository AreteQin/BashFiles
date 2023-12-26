#sudo apt-get install python3-wstool python3-catkin-tools ros-${ROS_DISTRO}-cmake-modules protobuf-compiler autoconf ros-${ROS_DISTRO}-grpc -y

mkdir -p ~/voxblox_ws/src
cd ~/voxblox_ws
catkin init
catkin config --extend /opt/ros/noetic
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release
catkin config --merge-devel

cd ~/voxblox_ws/src/
git clone git@github.com:ethz-asl/voxblox.git
wstool init . ./voxblox/voxblox_ssh.rosinstall
wstool update

cd ~/voxblox_ws/src/
catkin build voxblox_ros