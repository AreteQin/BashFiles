cd ~
mkdir svo_ws 
cd svo_ws
sudo apt-get install python3-catkin-tools python3-vcstool python3-osrf-pycommon -y
sudo apt-get install libglew-dev libopencv-dev libyaml-cpp-dev  -y
sudo apt-get install libblas-dev liblapack-dev libsuitesparse-dev -y
# see below for the reason for specifying the eigen path
catkin config --init --mkdirs --extend /opt/ros/noetic --cmake-args -DCMAKE_BUILD_TYPE=Release -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3
cd src
git clone git@github.com:uzh-rpg/rpg_svo_pro_open.git
vcs-import < ./rpg_svo_pro_open/dependencies.yaml
touch minkindr/minkindr_python/CATKIN_IGNORE
# vocabulary for place recognition
cd rpg_svo_pro_open/svo_online_loopclosing/vocabularies && ./download_voc.sh
cd ../../..