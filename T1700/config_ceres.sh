cd ~
sudo apt install liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev -y
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
mkdir build
cd build
cmake ..
make -j2
sudo make install
