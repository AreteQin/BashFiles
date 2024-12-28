# CUDA
echo "============================================="
echo "Have you installed CUDA? [y/n]"
read cuda

# Realsense
echo "============================================="
echo "Have you installed Realsense SDK? [y/n]"
read realsense

# Ceressolver
echo "============================================="
echo "Have you installed Ceres Solver? [y/n]"
read ceres

# G2O
echo "============================================="
echo "Have you installed G2O? [y/n]"
read g2o

# OpenGV
echo "============================================="
echo "Have you installed OpenGV? [y/n]"
read opengv

# Sophus
echo "============================================="
echo "Have you installed Sophus? [y/n]"
read sophus

sudo apt update -y
sudo apt upgrade -y
sudo apt-get install libopencv-dev libsuitesparse-dev libglew-dev libxmu-dev libxi-dev libgl-dev libx11-dev xorg-dev libglu1-mesa-dev freeglut3-dev libglew1.5 libglew1.5-dev libglu1-mesa libglu1-mesa-dev libgl1-mesa-glx libgl1-mesa-dev libeigen3-dev cmake libfontconfig1 perl python git libglew-dev libboost-all-dev zip unzip make gcc g++ wget build-essential qt5-default qtcreator libqt5x11extras5-dev -y

cd ~/Downloads/BashFiles

if [ "$realsense" = "n" ]; then
    ./install_realsense_driver.sh
fi

if [ "$cuda" = "n" ]; then
    ../install_cuda.sh
fi

sudo apt install ros-${ROS_DISTRO}-rgbd-launch -y
sudo apt install ros-${ROS_DISTRO}-realsense2-camera -y

# Ceres
if [ "$ceres" = "n" ]; then
    ./install_ceres.sh
fi

# G2O
if [ "$g2o" = "n" ]; then
    ./install_g2o.sh
fi

# OpenGV
if [ "$opengv" = "n" ]; then
    ./install_opengv.sh
fi

# Sophus
if [ "$sophus" = "n" ]; then
    ./install_sophus.sh
fi

cd ~/Downloads
git clone git@github.com:AreteQin/badslam_without_loop_detector.git

cd ~/Downloads/badslam_without_loop_detector
mkdir build_RelWithDebInfo && cd build_RelWithDebInfo 
cmake  -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CUDA_FLAGS="-arch=sm_75" .. 
make -j4 badslam