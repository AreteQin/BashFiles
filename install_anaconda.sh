echo "============================================="
echo "Have you downloaded the latest installation? (y/n)"
read download

cd ~/Downloads
if [ $download == "n" ]; then
    wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
fi
chmod +x ./Anaconda3*.sh
./Anaconda3*.sh

~/anaconda3/bin/conda init
echo "conda deactivate" >> ~/.bashrc
source ~/.bashrc