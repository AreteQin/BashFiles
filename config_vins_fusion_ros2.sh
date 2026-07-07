cd ~/Downloads
git clone https://github.com/zinuok/VINS-Fusion-ROS2.git

## install ceres-2.1.0
read -p "Have you installed CUDA? (y/n) " cuda

case ${cuda} in
    "y"|"Y")
        echo "Install Ceres Solver 2.1.0"

        read -p "Enter number of threads to use for compilation (default: $(nproc)): " num_threads
        if [ -z "${num_threads}" ]; then
            num_threads=$(nproc)
        fi
        echo "Will compile using ${num_threads} thread(s)."

        cd ~
        sudo apt update
        sudo apt install cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev -y
                
        # Clone the specific version provided by the user
        git clone https://github.com/ceres-solver/ceres-solver.git -b 2.1.0
                
        cd ceres-solver
        mkdir -p ceres-bin
        cd ceres-bin
                
        # Run cmake with or without the custom prefix flag
        cmake .. -DCMAKE_INSTALL_PREFIX=/opt/ceres_2.1.0 -DCMAKE_BUILD_TYPE=Release
                
        # Use the user-defined number of threads for compilation
        make -j${num_threads}
                
        # Install the compiled binaries
        sudo make install

        # Compile VINS-Fusion-ROS2
        cd ~/Downloads/VINS-Fusion-ROS2
        colcon build --cmake-args -DCMAKE_PREFIX_PATH=/opt/ceres_2.1.0
        echo "Installation complete!"
        ;;
    "n"|"N")
        echo "Please install CUDA first"
        echo "Exiting..."
        exit 1
        ;;
    *)
        echo "Invalid input. Exiting..."
        exit 1
        ;;
esac