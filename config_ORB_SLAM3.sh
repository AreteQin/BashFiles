echo "Please install the Pangolin first and continue"
read pangolin

echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:~/ORB_SLAM3_Ubuntu_20/Examples_old/ROS" >> ~/.bashrc

. ~/.bashrc

cd ~

git clone https://github.com/AreteQin/ORB_SLAM3_Ubuntu_20.git

sudo apt install ros-noetic-vision-msgs -y

cd ORB_SLAM3_Ubuntu_20

sudo ldconfig

bash ./build.sh
cd ~/ORB_SLAM3_Ubuntu_20/
./build_ros.sh