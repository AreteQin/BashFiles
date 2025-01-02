echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

echo "Have you installed TensorRT? (y/n)"
read tensorrt

if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi

if [ "$tensorrt" = "n" ]; then
    ./install_tensorRT.sh
fi

echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc
sudo apt install python3-pip -y
python3 -m pip install deface
python3 -m pip install onnx onnxruntime-gpu
echo "============================================="
echo "Deface installed!"
. ~/.bashrc
echo "Usage: deface /path/to/image"