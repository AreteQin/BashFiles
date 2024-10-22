# CUDA

echo "============================================="
echo "Have you downloaded CUDA installer? [y/n]"
read cuda

cd ~/Downloads

case ${cuda} in
    "n")
        echo "Downloading..."
        wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
        ;;
esac

sudo sh cuda_11.6.0_510.39.01_linux.run

# Append CUDA paths to ~/.bashrc
echo "export PATH=/usr/local/cuda-11.6/bin\${PATH:+:\${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}" >> ~/.bashrc

# Reload ~/.bashrc to apply changes
source ~/.bashrc