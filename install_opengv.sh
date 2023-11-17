cd ~
git clone https://github.com/laurentkneip/opengv
cd opengv
mkdir build && cd build && cmake .. && make -j6
sudo make install