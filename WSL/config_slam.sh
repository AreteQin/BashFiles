cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build
cmake ..
make -j12
sudo make install

cd ~
sudo apt install liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev -y
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
mkdir build
cd build
cmake ..
make -j12
sudo make install

cd ~
sudo apt install libsuitesparse-dev libqglviewer-dev-qt5 -y
git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
mkdir build
cd build
cmake ..
make -j12
sudo make install

cd ~
sudo apt install python3-pip libeigen3-dev -y
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin 
# Install dependencies (as described above, or your preferred method)
./scripts/install_prerequisites.sh recommended
# Configure and build
mkdir build && cd build
cmake ..
cmake --build .
# GIVEME THE PYTHON STUFF!!!! (Check the output to verify selected python version)
cmake --build . -t pypangolin_pip_install

sudo apt install liboctomap-dev octovis
