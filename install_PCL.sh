sudo apt-get install libflann1.9 libflann-dev libpcl-dev pcl-tools -y
cd ~
git clone git@github.com:PointCloudLibrary/pcl.git
cd pcl
mkdir release && cd release
cmake -DCMAKE_BUILD_TYPE=None -DCMAKE_INSTALL_PREFIX=/usr \ -DBUILD_GPU=ON-DBUILD_apps=ON -DBUILD_examples=ON \ -DCMAKE_INSTALL_PREFIX=/usr .. 
make -j4
sudo make install