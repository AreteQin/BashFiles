#!/bin/bash
# setup_cosmos3.sh - Setup script for NVIDIA Cosmos 3 Framework on Ubuntu 22.04
set -e

# Configuration
WORKSPACE_DIR="$HOME/cosmos-workspace"
# FIX 1: Point to the actual framework repository, not the docs repo
COSMOS_REPO="https://github.com/NVIDIA/cosmos-framework.git" 
FOLDER_NAME="cosmos-framework"
# FIX 2: Set to 12.8 to match the CUDA version you just installed
CUDA_GROUP="cu128-train" 

echo "==========================================================="
echo "  NVIDIA Cosmos 3 Setup Script for Ubuntu 22.04"
echo "==========================================================="

echo "[1/5] Updating system and installing dependencies..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    curl \
    ffmpeg \
    git-lfs \
    libx11-dev \
    tree \
    wget

echo "[2/5] Installing 'uv' package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"

echo "[3/5] Setting up workspace and cloning NVIDIA Cosmos Framework..."
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

if [ ! -d "$FOLDER_NAME" ]; then
    git clone "$COSMOS_REPO" "$FOLDER_NAME"
else
    echo "Cosmos framework repository already exists. Pulling latest..."
    cd "$FOLDER_NAME"
    git pull
    cd ..
fi

cd "$FOLDER_NAME"

echo "[4/5] Synchronizing dependencies and creating virtual environment..."
# uv sync reads pyproject.toml in cosmos-framework and builds the environment
uv sync --all-extras --group="$CUDA_GROUP"

echo "[5/5] Installing Hugging Face CLI for downloading model weights..."
source .venv/bin/activate
export LD_LIBRARY_PATH=""
uv pip install -U "huggingface_hub[cli]"

echo "==========================================================="
echo "  Installation Complete!"
echo "==========================================================="
echo ""
echo "To start using Cosmos 3, follow these final steps:"
echo "1. Activate your new CUDA toolkit: use_cuda_12.8"
echo "2. Navigate to the repository: cd $WORKSPACE_DIR/$FOLDER_NAME"
echo "3. Activate your environment: source .venv/bin/activate"
echo "4. Authenticate with Hugging Face: hf auth login"
echo ""
