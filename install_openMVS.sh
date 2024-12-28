# Extract Ubuntu version
UBUNTU_VERSION=$(lsb_release -r | awk '{print $2}')

# Print the Ubuntu version
echo "Ubuntu version: $UBUNTU_VERSION"

if [ "$UBUNTU_VERSION" = "20.04" ]; then
    ./install_openMVS_ubuntu20.sh
    exit
fi

sudo apt install libglfw3-dev python3-dev libboost-all-dev libopencv-dev -y

echo "Confirm your GPU Compute Capability according to the opened website"
google-chrome https://developer.nvidia.com/cuda-gpus
echo "Please type your GPU Compute Capability (e.g. 75):"
read GPU_COMPUTE_CAPABILITY

echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi

cd ~
#Clone OpenMVS
git clone --recurse-submodules https://github.com/cdcseacave/openMVS.git --branch v2.3.0

#Make build directory:
cd openMVS
git clone -b devel https://github.com/cnr-isti-vclab/vcglib.git
mkdir make
cd make

#Run CMake:
# cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES="$GPU_COMPUTE_CAPABILITY" -DVCG_ROOT="../vcglib"
cmake .. -DCMAKE_BUILD_TYPE=Release -DVCG_ROOT="../vcglib" -DCMAKE_CUDA_FLAGS="-arch=sm_75"

#Build:
cmake --build . -j4

#Install OpenMVS library (optional):
sudo cmake --install .

echo "export PATH=\${PATH}:$(pwd)/bin" >> ~/.bashrc