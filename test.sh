# Add CUDA to bashrc
echo "Add the following to your ~/.bashrc file"
echo "============================================="
echo "export PATH=/usr/local/cuda-11.6/bin\${PATH:+:\${PATH}}"
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"

Var=$(lsb_release -cs)
echo "$Var"