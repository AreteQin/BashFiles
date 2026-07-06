#!/bin/bash

read -p "Have you installed CUDA? (y/n) " cuda

case ${cuda} in
    "y"|"Y")
        echo "How would you like to install Ceres Solver?"
        echo "1) apt default (libceres-dev)"
        echo "2) Compile from source"
        read -p "Enter your choice [1 or 2]: " install_choice

        case ${install_choice} in
            1)
                echo "Installing Ceres via apt..."
                sudo apt update
                sudo apt install libceres-dev -y
                ;;
            2)
                read -p "Enter the Ceres version to clone (e.g., 2.2.0): " ceres_version
                
                # Ask about installation directory
                read -p "Install to the default system location (/usr/local)? (y/n) " default_loc
                
                cmake_args=".."
                case ${default_loc} in
                    "n"|"N")
                        read -p "Enter custom absolute installation path (e.g., /opt/ceres or ~/ceres_install): " custom_path
                        # Safely expand the tilde (~) if the user provides a home-relative path
                        custom_path="${custom_path/#\~/$HOME}"
                        cmake_args=".. -DCMAKE_INSTALL_PREFIX=${custom_path}"
                        echo "Will install to: ${custom_path}"
                        ;;
                    *)
                        echo "Will install to default location."
                        ;;
                esac

                # Ask about number of threads for compilation
                read -p "Enter number of threads to use for compilation (default: $(nproc)): " num_threads
                if [ -z "${num_threads}" ]; then
                    num_threads=$(nproc)
                fi
                echo "Will compile using ${num_threads} thread(s)."

                echo "Preparing to compile Ceres Solver version ${ceres_version} from source..."
                
                cd ~
                sudo apt update
                sudo apt install cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev -y
                
                # Clone the specific version provided by the user
                git clone https://github.com/ceres-solver/ceres-solver.git -b ${ceres_version}
                
                cd ceres-solver
                mkdir -p ceres-bin
                cd ceres-bin
                
                # Run cmake with or without the custom prefix flag
                cmake ${cmake_args}
                
                # Use the user-defined number of threads for compilation
                make -j${num_threads}
                
                # Install the compiled binaries
                sudo make install
                
                echo "Installation complete!"
                ;;
            *)
                echo "Invalid choice. Exiting..."
                exit 1
                ;;
        esac
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