sudo apt install libglfw3-dev python3-dev libboost-all-dev libopencv-dev -y

echo "Confirm your GPU Compute Capability according to the opened website"
google-chrome https://developer.nvidia.com/cuda-gpus
echo "Please type your GPU Compute Capability (e.g. 75):"
read GPU_COMPUTE_CAPABILITY

echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

if [ "$CUDA_TOOLKIT" = "n" ]; then
    sudo apt install nvidia-cuda-toolkit nvidia-cuda-toolkit-gcc -y
fi

cd ~
#Clone OpenMVS
git clone --recurse-submodules https://github.com/cdcseacave/openMVS.git

#Make build directory:
cd openMVS
git clone -b devel https://github.com/cnr-isti-vclab/vcglib.git
mkdir make
cd make

#Run CMake:
cmake .. -DCMAKE_CUDA_ARCHITECTURES="$GPU_COMPUTE_CAPABILITY" -DVCG_ROOT="../vcglib"

#Build:
cmake --build . -j4

#Install OpenMVS library (optional):
sudo cmake --install .

echo "export PATH=${PATH}:$(pwd)/bin" >> ~/.bashrc