sudo rosdep init && rosdep update

source ~/.bashrc 

mkdir -p ~/catkin_ws/src  

cd ~/catkin_ws/src 

catkin_init_workspace 

cd .. 

catkin build 

source devel/setup.bash
