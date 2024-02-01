echo "Have you installed CUDA? (y/n) "
read cuda

case ${cuda} in
    "y")
        cd ~
        sudo apt install liblapack-dev libsuitesparse-dev libcxsparse3 libgflags-dev libgoogle-glog-dev libgtest-dev -y
        git clone https://ceres-solver.googlesource.com/ceres-solver
        cd ceres-solver
        mkdir build
        cd build
        cmake ..
        make -j6
        sudo make install
        ;;
    "n")
        echo "Please install CUDA first"
        echo "Exiting..."
        exit
        ;;
esac