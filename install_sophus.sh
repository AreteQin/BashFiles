echo "Have you installed CUDA and Ceres manually? (y/n) "
read cuda

case ${cuda} in
    "y")
        echo "Downloading Sophus..."
        ;;
    "n")
        echo "Please install CUDA and Ceresfirst"
        echo "Exiting..."
        ;;
esac

cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build

echo "Have you modified the CMakeLists.txt? (y/n) "
read modified

case ${modified} in
    "y")
        sudo apt install libfmt-dev -y
        cmake ..
        make -j6
        sudo make install
        ;;
    "n")
        echo "Exiting..."
        ;;
esac
