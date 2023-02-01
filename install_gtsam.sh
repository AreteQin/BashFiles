#!/usr/bin/env bash

# sudo add-apt-repository ppa:borglab/gtsam-release-4.0
# sudo apt update  # not necessary since Bionic
# # Install:
# sudo apt install libgtsam-dev libgtsam-unstable-dev

## for DM-VIO
sudo apt install libtbb-dev
cd ~
git clone https://github.com/borglab/gtsam.git
cd gtsam
git checkout 4.2a6          # not strictly necessary but this is the version tested with.
mkdir build && cd build
cmake -DGTSAM_POSE3_EXPMAP=ON -DGTSAM_ROT3_EXPMAP=ON -DGTSAM_USE_SYSTEM_EIGEN=ON -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF ..
make -j8
sudo make install
## add 
## export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
## to ~/.bashrc 