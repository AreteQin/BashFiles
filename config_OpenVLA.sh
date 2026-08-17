#!/bin/bash
# OpenVLA Setup Script for Ubuntu 22.04

set -e # Exit immediately if a command fails

echo "Starting OpenVLA setup on Ubuntu 22.04..."

# 1. Install system dependencies
echo "Installing system-level dependencies..."
sudo apt update
sudo apt install -y git wget curl ninja-build build-essential

# 2. Install Miniconda (if not already installed)
if ! command -v conda &> /dev/null
then
    echo "Miniconda not found. Installing Miniconda..."
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    source ~/miniconda3/bin/activate
    conda init bash
else
    echo "Miniconda is already installed."
    source $(conda info --base)/etc/profile.d/conda.sh
fi

# 3. Create and activate the Conda environment
ENV_NAME="openvla"
echo "Creating Conda environment: $ENV_NAME (Python 3.10)..."
conda create -n $ENV_NAME python=3.10 -y
conda activate $ENV_NAME

# 4. Install PyTorch with CUDA 12.4
echo "Installing PyTorch..."
conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia -y

# 5. Clone the repository
echo "Cloning OpenVLA repository..."
cd ~
if [ ! -d "openvla" ]; then
    git clone https://github.com/openvla/openvla.git
fi
cd openvla

# 6. Install OpenVLA
echo "Installing OpenVLA..."
pip install -e .

# 7. Install quantization tools for 8GB/12GB VRAM cards
echo "Installing bitsandbytes and accelerate for 4-bit quantization..."
pip install accelerate bitsandbytes

# 8. Install Flash Attention 2
echo "Installing Flash Attention 2..."
pip install packaging ninja
pip install "flash-attn==2.5.5" --no-build-isolation

echo "=========================================================="
echo "OpenVLA setup complete!"
echo "To start using your new environment, run:"
echo "source ~/miniconda3/bin/activate && conda activate openvla"
echo "=========================================================="