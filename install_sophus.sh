#!/bin/sh

echo "Have you installed CUDA and Ceres manually? (y/n) "
read cuda

case ${cuda} in
    "y")
        echo "Downloading Sophus..."
        ;;
    "n")
        echo "Please install CUDA and Ceres first"
        echo "Exiting..."
        exit
        ;;
esac

cd ~
git clone https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build
cd build

echo "============================================="
echo "find_package(CUDA REQUIRED)"
echo "if (CUDA_FOUND)"
echo "   enable_language(CUDA)"
echo "    macro(DECLARE_IMPORTED_CUDA_TARGET COMPONENT)"
echo "        add_library(CUDA::${COMPONENT} INTERFACE IMPORTED)"
echo "        target_include_directories(CUDA::${COMPONENT} INTERFACE ${CUDA_INCLUDE_DIRS})"
echo "        target_link_libraries(CUDA::${COMPONENT} INTERFACE ${CUDA_${COMPONENT}_LIBRARY} ${ARGN})"
echo "    endmacro()"
echo "    declare_imported_cuda_target(cublas)"
echo "    declare_imported_cuda_target(cusolver)"
echo "    declare_imported_cuda_target(cusparse)"
echo "    declare_imported_cuda_target(cudart ${CUDA_LIBRARIES})"
echo "   set(CUDAToolkit_BIN_DIR ${CUDA_TOOLKIT_ROOT_DIR}/bin)"
echo "else (CUDA_FOUND)"
echo "    message("-- Did not find CUDA, disabling CUDA support.")"
echo "    update_cache_variable(USE_CUDA OFF)"
echo "endif (CUDA_FOUND)"
echo "set(CUDA_ADD_CUBLAS_TO_TARGET ON)"
echo "============================================="
echo "Have you added the above code into the CMakeLists.txt? (y/n) "

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
        exit
        ;;
esac
