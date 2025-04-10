cd ~

echo "============================================="
echo "Installing Pangolin, choose platform"
echo "(1) x86_64"
echo "(2) Jetson Xavier"
read system

sudo apt install python3-pip libeigen3-dev libepoxy-dev -y
git clone --recursive https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin 

# Install dependencies (as described above, or your preferred method)
./scripts/install_prerequisites.sh recommended

# Configure and build
mkdir build
cd build

case ${system} in
    "1")
        cmake ..
        ;;
    "2")
        sudo apt install python3.9-dev -y
        cmake .. -DPython_EXECUTABLE=/usr/bin/python3.8 # for Jetson Xavier Ubuntu 20
        ;;
esac

cmake --build .
sudo make install

# GIVEME THE PYTHON STUFF!!!! (Check the output to verify selected python version)
# cmake --build . -t pypangolin_pip_install

## for dm-vio
# sudo apt install libgl1-mesa-dev libglew-dev pkg-config libegl1-mesa-dev libwayland-dev libxkbcommon-dev wayland-protocols
# git clone https://github.com/stevenlovegrove/Pangolin.git
# cd Pangolin
# git checkout v0.6
# mkdir build
# cd build
# cmake ..
# cmake --build .
# sudo make install
