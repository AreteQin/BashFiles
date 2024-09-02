# Add CUDA to bashrc
echo "Add the following to your ~/.bashrc file"
echo "============================================="
echo "export PATH=/usr/local/cuda-11.6/bin\${PATH:+:\${PATH}}"
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"

# Print the version of Ubuntu
Var=$(lsb_release -cs)
echo "$Var"

sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install ffmpeg obs-studio -y