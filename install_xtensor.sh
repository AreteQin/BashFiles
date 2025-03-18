cd ~
git clone https://github.com/xtensor-stack/xtensor.git
cd xtensor
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j2
sudo make install