sudo apt install ros-${ROS_DISTRO}-nmea-msgs libsdl2-dev -y
cd ~/Downloads
git clone https://github.com/AreteQin/dji_osdk_410_opencv4.git
cd dji_osdk_410_opencv4/
mkdir build && cd build && cmake -DADVANCED_SENSING=ON .. && make -j4
sudo make install
cd ~
git clone https://github.com/AreteQin/m300_ws.git
cd m300_ws
catkin build