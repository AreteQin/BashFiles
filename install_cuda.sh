# CUDA

echo "============================================="
echo "Have you downloaded CUDA installer? [y/n]"
read cuda

cd ~/Downloads

case ${cuda} in
    "n")
        echo "Downloading..."
        wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
        ;;
esac

sudo sh cuda_*.run

# Append CUDA paths to ~/.bashrc
echo "export PATH=/usr/local/cuda-11.8/bin\${PATH:+:\${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}" >> ~/.bashrc

# Reload ~/.bashrc to apply changes
source ~/.bashrc

# sudo apt install nvidia-cuda-toolkit nvidia-cuda-toolkit-gcc -y # the default version is too old CUDA version