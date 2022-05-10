cd ~
git clone https://github.com/laurentkneip/opengv
cd opengv
mkdir build && cd build && cmake .. && make -j12
sudo make install