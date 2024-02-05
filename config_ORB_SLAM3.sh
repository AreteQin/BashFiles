echo "============================================="
echo export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:~/ORB_SLAM3_Ubuntu_20/Examples_old/ROS
echo "============================================="
echo "Please add the above code into the ~/.bashrc? (y/n) "

gedit ~/.bashrc

read modified

cd ~

git clone https://github.com/AreteQin/ORB_SLAM3_Ubuntu_20.git

sudo apt install ros-noetic-vision-msgs -y

cd ORB_SLAM3_Ubuntu_20

sudo ldconfig

bash ./build.sh

bash ./build_ros.sh