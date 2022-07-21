cd ~
sudo apt install libfmt-dev
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build
cmake ..
make -j6
sudo make install
