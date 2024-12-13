#!/bin/bash

# Step 1: Initialize Conda
source ~/anaconda3/etc/profile.d/conda.sh

echo "============================================="
echo "Have you installed Anaconda? (y/n)"
read anaconda

echo "============================================="
echo "Have you installed CUDA? (y/n)"
read cuda

if [ $anaconda == "n" ]; then
    echo "Installing Anaconda..."
    ~/Downloads/BashFiles/install_anaconda.sh
fi

if [ $cuda == "n" ]; then
    echo "Installing CUDA..."
    ~/Downloads/BashFiles/install_cuda.sh
fi

conda create -n pytorch3d python=3.9
conda init
conda activate pytorch3d
conda install pytorch=1.13.0 torchvision pytorch-cuda=11.6 -c pytorch -c nvidia
conda install -c iopath iopath

# Demos and examples
conda install jupyter
pip install scikit-image matplotlib imageio plotly opencv-python

# Tests/Linting
conda install -c fvcore -c conda-forge fvcore && pip install black usort flake8 flake8-bugbear flake8-comprehensions

# Anaconda Cloud
conda install pytorch3d -c pytorch3d