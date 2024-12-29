# Extract Ubuntu version
UBUNTU_VERSION=$(lsb_release -r | awk '{print $2}')

# Print the Ubuntu version
echo "Ubuntu version: $UBUNTU_VERSION"

echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

echo "Have you installed Ceres? (y/n)"
read ceres

echo "Confirm your GPU Compute Capability according to the opened website"
google-chrome https://developer.nvidia.com/cuda-gpus
echo "Please type your GPU Compute Capability (e.g. 75):"
read GPU_COMPUTE_CAPABILITY

cd ~/Downloads/BashFiles

if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi

if [ "$ceres" = "n" ]; then
    ./install_ceres.sh
fi

cd ~

if [ "$UBUNTU_VERSION" = "20.04" ]; then
    # sudo apt -y install git cmake libpng-dev libjpeg-dev libtiff-dev libglu1-mesa-dev freeglut3-dev libglew-dev libglfw3-dev libcgal-dev libcgal-qt5-dev
    git clone https://github.com/AreteQin/openMVS_Ubuntu20.git
    cd openMVS_Ubuntu20
    git clone https://gitlab.com/libeigen/eigen.git --branch 3.4
    cd eigen/
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=../install
    make install
    cd ~/openMVS_Ubuntu20
else
    git clone --recurse-submodules https://github.com/cdcseacave/openMVS.git --branch v2.3.0
    cd ~/openMVS
fi

sudo apt install libglfw3-dev python3-dev libboost-all-dev libopencv-dev -y

#Make build directory:
git clone -b devel https://github.com/cnr-isti-vclab/vcglib.git
mkdir make
cd make

#Run CMake:
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES="$GPU_COMPUTE_CAPABILITY" -DVCG_ROOT="../vcglib"

#Build:
cmake --build . -j4

#Install OpenMVS library (optional):
sudo cmake --install .

echo "export PATH=\${PATH}:$(pwd)/bin" >>~/.bashrc
