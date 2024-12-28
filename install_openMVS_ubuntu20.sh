echo "Confirm your GPU Compute Capability according to the opened website"
google-chrome https://developer.nvidia.com/cuda-gpus
echo "Please type your GPU Compute Capability (e.g. 75):"
read GPU_COMPUTE_CAPABILITY

sudo apt -y install git cmake libpng-dev libjpeg-dev libtiff-dev libglu1-mesa-dev freeglut3-dev libglew-dev libglfw3-dev libcgal-dev libcgal-qt5-dev
cd ~
mkdir openMVS && cd openMVS
git clone https://github.com/cdcseacave/VCG.git vcglib
git clone https://gitlab.com/libeigen/eigen.git --branch 3.4
cd eigen/
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../install
make install
cd ../..
git clone https://github.com/AreteQin/openMVS_Ubuntu20.git
cd openMVS_Ubuntu20
mkdir openMVS_build && cd openMVS_build
cmake .. -DCMAKE_BUILD_TYPE=Release -DVCG_ROOT="../../vcglib" -DCMAKE_CUDA_FLAGS="-arch=sm_${GPU_COMPUTE_CAPABILITY}"
make -j6
echo "export PATH=\${PATH}:$(pwd)/bin" >> ~/.bashrc