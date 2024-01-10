sudo apt install ros-${ROS_DISTRO}-nmea-msgs libsdl2-dev -y
sudo apt install ros-noetic-rosserial-msgs -y
pip3 install pyserial
cd ~/Downloads
git clone https://github.com/AreteQin/dji_osdk_410_opencv4.git
cd dji_osdk_410_opencv4/
mkdir build && cd build && cmake -DADVANCED_SENSING=ON .. && make -j4
sudo make install
cd ~
git clone https://github.com/AreteQin/m300_ws.git

# for Yolo
sudo apt install python3-pip -y
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip3 install ultralytics