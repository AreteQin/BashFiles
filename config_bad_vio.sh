# Add CUDA to bashrc
echo "Add the following to your ~/.bashrc file"
echo "============================================="
echo "export PATH=/usr/local/cuda-11.6/bin\${PATH:+:\${PATH}}"
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"

gedit ~/.bashrc

# Realsense
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

# CUDA
echo "============================================="
echo "Have you downloaded CUDA installer? [y/n]"
read cuda
cd ~/Downloads
case ${cuda} in
    "n")
        echo "Downloading..."
        wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
        ;;
esac
sudo sh cuda_11.6.0_510.39.01_linux.run

# Ceres
cd ~
sudo apt install liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev -y
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ceres-solver
mkdir build
cd build
cmake ..
make -j6
sudo make install

# G2O
case ${system} in
    "1")
        # For x86_64 
        cd ~
        sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
        git clone https://github.com/RainerKuemmerle/g2o.git
        cd g2o
        mkdir build
        cd build
        cmake ..
        make -j6
        sudo make install
        ;;
    "2")
        # For QCar
        cd ~
        sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
        git clone https://github.com/RainerKuemmerle/g2o.git
        cd g2o
        mkdir build
        cd build
        cmake ..
        make -j2
        sudo make install
        ;;
esac

# Opengv
cd ~
git clone https://github.com/laurentkneip/opengv
cd opengv
mkdir build && cd build && cmake .. && make -j6
sudo make install