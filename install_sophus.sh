#!/bin/bash

echo "Have you installed CUDA manually? (y/n) "
read cuda

case ${cuda} in
    "n")
        echo "Installing Ceres"
        cd ~/Downloads/BashFiles/
        ./install_cuda.sh
        . ~/.bashrc
        ;;
esac

echo "Have you installed Ceres manually? (y/n) "
read ceres

case ${ceres} in
    "y")
        echo "Downloading Sophus..."
        ;;
    "n")
        echo "Installing Ceres"
        cd ~/Downloads/BashFiles/
        ./install_ceres.sh
        ;;
esac

cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
git checkout tags/1.22.10
mkdir build
cd build

echo "Add the code below into the CMakeLists.txt. Also check the CMake version and Eigen version. "
echo "============================================="
echo "find_package(CUDA REQUIRED)"
echo "if (CUDA_FOUND)"
echo "   enable_language(CUDA)"
echo "    macro(DECLARE_IMPORTED_CUDA_TARGET COMPONENT)"
echo "        add_library(CUDA::\${COMPONENT} INTERFACE IMPORTED)"
echo "        target_include_directories(CUDA::\${COMPONENT} INTERFACE \${CUDA_INCLUDE_DIRS})"
echo "        target_link_libraries(CUDA::\${COMPONENT} INTERFACE \${CUDA_\${COMPONENT}_LIBRARY} \${ARGN})"
echo "    endmacro()"
echo "    declare_imported_cuda_target(cublas)"
echo "    declare_imported_cuda_target(cusolver)"
echo "    declare_imported_cuda_target(cusparse)"
echo "    declare_imported_cuda_target(cudart \${CUDA_LIBRARIES})"
echo "   set(CUDAToolkit_BIN_DIR \${CUDA_TOOLKIT_ROOT_DIR}/bin)"
echo "else (CUDA_FOUND)"
echo "    message("-- Did not find CUDA, disabling CUDA support.")"
echo "    update_cache_variable(USE_CUDA OFF)"
echo "endif (CUDA_FOUND)"
echo "set(CUDA_ADD_CUBLAS_TO_TARGET ON)"
echo "============================================="
echo "Have you added the above code into the CMakeLists.txt? (y/n) "
echo "This installation requires a lot of memory, please make sure you have turn off Clion and browser!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

gedit ../CMakeLists.txt

read modified

case ${modified} in
    "y")
        sudo apt install libfmt-dev -y
        cmake ..
        make -j4
        sudo make install
        ;;
    "n")
        echo "Exiting..."
        exit
        ;;
esac
