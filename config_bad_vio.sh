# ROS
echo "============================================="
echo "Have you installed ROS? [y/n]"
read ros

if [ "$ros" = "n" ]; then
    echo "Please install ROS first"
    exit
fi

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

cd ~
mkdir -p bad_vio_ws/src
cd bad_vio_ws/src
git clone git@github.com:AreteQin/bad_vio_ros.git
cd ..
catkin build