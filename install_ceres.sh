echo "Have you installed CUDA? (y/n) "
read cuda

case ${cuda} in
    "y")
        # cd ~
        # sudo apt install cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev -y
        # git clone https://github.com/ceres-solver/ceres-solver.git -b 2.2.0
        # cd ceres-solver
        # mkdir ceres-bin
        # cd ceres-bin
        # cmake ..
        # make -j3
        # sudo make install
        sudo apt install libceres-dev -y
        ;;
    "n")
        echo "Please install CUDA first"
        echo "Exiting..."
        exit
        ;;
esac