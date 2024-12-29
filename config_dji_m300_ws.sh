echo "============================================="
echo "Choose your platform for pytorch installation"
echo "(1) x86_64"
echo "(2) Jetson"
echo "(3) Skip installation for pytorch"
read system

. /opt/ros/noetic/setup.bash
sudo apt install ros-${ROS_DISTRO}-nmea-msgs libsdl2-dev libgoogle-glog-dev ros-${ROS_DISTRO}-rosserial-msgs ros-${ROS_DISTRO}-vision-msgs -y

pip3 install pyserial

cd ~/Downloads
git clone https://github.com/AreteQin/dji_osdk_410_opencv4.git
cd dji_osdk_410_opencv4/
mkdir build
cd build
cmake -DADVANCED_SENSING=ON ..
make -j4
sudo make install
cd ~
git clone https://github.com/AreteQin/m300_ws.git

# for Yolo
case ${system} in
    "1")
        sudo apt install python3-pip -y
        pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
        pip3 install ultralytics
        ;;
    "2")
        wget files.seeedstudio.com/YOLOv8-Jetson.py && python3 YOLOv8-Jetson.py
        ;;
    "3")
        echo "Skip installation for pytorch"
        echo "Exiting..."
        exit
        ;;
esac