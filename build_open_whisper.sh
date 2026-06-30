echo "Have you installed CUDA Toolkit? (y/n)"
read CUDA_TOOLKIT

cd ~/Downloads/BashFiles

if [ "$CUDA_TOOLKIT" = "n" ]; then
    ./install_cuda.sh
fi

cd ~/Downloads

git clone https://github.com/ggerganov/whisper.cpp.git

sudo apt install nvidia-cuda-toolkit build-essential

cd ./whisper.cpp

cmake -B build -DGGML_CUDA=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES=86 -DGGML_CUDA_FA=OFF

cmake --build build -j$(nproc) --config Release

## Download the model files
curl -L -x http://192.168.5.7:9090 https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3.bin -o ~/.cache/openwhispr/whisper-models/ggml-large-v3.bin