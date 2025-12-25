echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT
echo "Have you downlaoded the the specific version of TensorRT according to your Ubuntu version and CUDA version? (y/n)"
read tensorrt
if [ "$tensorrt" = "n" ]; then
    echo "Please download the specific version of TensorRT in the opened website and continue"
    google-chrome https://developer.nvidia.com/tensorrt/download/10x
fi
if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi
read -n 1 -s -r -p "Press any key to continue when the download is finished..."

cd ~/Downloads
sudo dpkg -i nv-tensorrt-local-repo-*.deb
sudo cp /var/nv-tensorrt-local-repo-*/*-keyring.gpg /usr/share/keyrings/
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update