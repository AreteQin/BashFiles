cd ~
mkdir gvins_ws && cd gvins_ws
mkdir src && cd src
git clone https://github.com/HKUST-Aerial-Robotics/gnss_comm.git
git clone https://github.com/AreteQin/GVINS_Ubuntu_20.git
cd ..
catkin build