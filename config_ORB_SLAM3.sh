echo "Have you installed Pangolin"
read pangolin

if [ ${pangolin} == "n" ]; then
    cd ~/Downloads/BashFiles/
    bash ./install_pangolin.sh
fi

echo "Would you like to build ORB_SLAM3 ROS1 package? (y/n)"
read orbslam3_ros1
# echo "============================================="
# echo "Would you like to config for orbslam3_ros2? (y/n)"
# read orbslam3_ros2

. ~/.bashrc

cd ~

git clone https://github.com/AreteQin/ORB_SLAM3_Ubuntu_20.git

cd ORB_SLAM3_Ubuntu_20

sudo ldconfig

bash ./build.sh

if [ ${orbslam3_ros1} == "y" ]; then
    echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:~/ORB_SLAM3_Ubuntu_20/Examples_old/ROS" >>~/.bashrc
    cd ~/ORB_SLAM3_Ubuntu_20/
    sudo apt install ros-${ROS_DISTRO}-vision-msgs -y
    ./build_ros.sh
fi

# if [ ${orbslam3_ros2} == "y" ]; then
#     echo "export LD_LIBRARY_PATH=~/ORB_SLAM3_Ubuntu_20/lib:~/Pangolin/build/:~/ORB_SLAM3_Ubuntu_20/Thirdparty/DBoW2/lib:~/ORB_SLAM3_Ubuntu_20/Thirdparty/g2o/lib:\$LD_LIBRARY_PATH" >>~/.bashrc
# fi