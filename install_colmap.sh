echo "Installing COLMAP"
echo "Confirm your GPU Compute Capability according to the opened website"
google-chrome https://developer.nvidia.com/cuda-gpus
echo "Please type your GPU Compute Capability (e.g. 75):"
read GPU_COMPUTE_CAPABILITY

echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

sudo apt install git cmake ninja-build build-essential libboost-program-options-dev libboost-graph-dev libboost-system-dev libeigen3-dev libflann-dev libfreeimage-dev libmetis-dev libgoogle-glog-dev libgtest-dev libgmock-dev libsqlite3-dev libglew-dev qtbase5-dev libqt5opengl5-dev libcgal-dev libceres-dev -y

cd ~/Downloads/BashFiles

if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi

cd ~
git clone https://github.com/colmap/colmap.git --branch 3.11.1

cd colmap
git checkout 3.11.1
mkdir build
cd build
# cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES="$GPU_COMPUTE_CAPABILITY"
cmake .. -GNinja -DCMAKE_CUDA_FLAGS="-arch=sm_75"
ninja
sudo ninja install
colmap gui
