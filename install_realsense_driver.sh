echo "============================================="
echo "Installing Intel Realsense driver, choose platform"
echo "(1) x86_64"
echo "(2) QCar"
read system

case ${system} in
    "1")
        # For x86_64 
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
        sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
        sudo apt install librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg -y
        ;;
    "2")
        # For QCar
        sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
        sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo bionic main" -u
        sudo apt-get install librealsense2-utils -y
        sudo apt-get install librealsense2-dev -y
        sudo apt-get install librealsense2-dbg -y
        sudo apt-get install librealsense2-dkms -y
        ;;
esac

sudo apt install ros-${ROS_DISTRO}-rgbd-launch -y
sudo apt install ros-${ROS_DISTRO}-realsense2-camera -y
