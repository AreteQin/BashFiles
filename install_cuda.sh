# CUDA
cd ~/Downloads
wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
sudo sh cuda_11.6.0_510.39.01_linux.run

# Add CUDA to bashrc
echo "Add the following to your ~/.bashrc file"
echo "============================================="
echo "export PATH=/usr/local/cuda-11.6/bin\${PATH:+:\${PATH}}"
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"

gedit ~/.bashrc