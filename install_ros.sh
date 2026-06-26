#!/bin/bash
#
# Auto-installer for ROS 1 / ROS 2 based on Ubuntu distribution.
# Supports:
# - Ubuntu 18.04 (Bionic) -> ROS 1 Melodic
# - Ubuntu 20.04 (Focal)  -> ROS 1 Noetic OR ROS 2 Foxy (prompts user)
# - Ubuntu 22.04 (Jammy)  -> ROS 2 Humble
# - Ubuntu 24.04 (Noble)  -> ROS 2 Jazzy

set -e # Exit immediately if a command exits with a non-zero status

# --- Helper Function for ~/.bashrc ---
add_to_bashrc() {
    local SOURCE_LINE="$1"
    local BASHRC_FILE=~/.bashrc
    if ! grep -q -F "$SOURCE_LINE" "$BASHRC_FILE"; then
        echo "$SOURCE_LINE" >> "$BASHRC_FILE"
        echo "✅ Added '$SOURCE_LINE' to $BASHRC_FILE"
    else
        echo "ℹ️ '$SOURCE_LINE' already exists in $BASHRC_FILE"
    fi
}

# --- Detect Ubuntu Version ---
UBUNTU_CODENAME=$(lsb_release -sc)
echo "============================================="
echo "Detected Ubuntu version: $UBUNTU_CODENAME"
echo "============================================="

case ${UBUNTU_CODENAME} in
    "bionic")
        echo "Starting ROS 1 Melodic installation for Ubuntu 18.04..."
        sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
        sudo apt install curl -y
        curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
        sudo apt update -y
        sudo apt install ros-melodic-desktop-full -y
        
        add_to_bashrc "source /opt/ros/melodic/setup.bash"
        add_to_bashrc "source ~/catkin_ws/devel/setup.bash"
        add_to_bashrc "#export ROS_IP=192.168.1.12"
        add_to_bashrc "#export ROS_MASTER_URI=http://192.168.1.12:11311"
        
        sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y
        sudo apt-get install ros-melodic-catkin python-catkin-tools -y
        
        if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rosdep init; fi
        rosdep update
        echo "🎉 ROS 1 Melodic installation complete!"
        ;;

    "focal")
        echo "Ubuntu 20.04 supports both ROS 1 and ROS 2."
        echo "Which would you like to install?"
        echo "(1) ROS 1 Noetic"
        echo "(2) ROS 2 Foxy"
        read -p "Enter 1 or 2: " focal_choice

        if [ "$focal_choice" = "1" ]; then
            echo "Installing ROS 1 Noetic. Choose platform:"
            echo "(1) x86_64 or Jetson"
            echo "(2) Raspberry Pi"
            read -p "Enter 1 or 2: " system

            sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' 
            sudo apt install curl -y
            curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - 
            sudo apt update -y

            if [ "$system" = "1" ]; then
                sudo apt install ros-noetic-desktop-full -y
            else
                sudo apt install ros-noetic-desktop -y
            fi

            add_to_bashrc "source /opt/ros/noetic/setup.bash"
            add_to_bashrc "#export ROS_IP=192.168.99.120"
            add_to_bashrc "#export ROS_MASTER_URI=http://192.168.99.107:11311"

            sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
            sudo apt-get install python3-catkin-tools python3-vcstool python3-osrf-pycommon -y
            
            if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rosdep init; fi
            rosdep update
            echo "🎉 ROS 1 Noetic installation complete!"

        elif [ "$focal_choice" = "2" ]; then
            echo "Installing ROS 2 Foxy..."
            sudo apt install software-properties-common -y
            sudo add-apt-repository universe -y
            sudo apt update && sudo apt install curl -y
            sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
            sudo apt update -y
            sudo apt upgrade -y
            sudo apt install ros-foxy-desktop python3-argcomplete -y
            sudo apt install ros-dev-tools -y
            add_to_bashrc "source /opt/ros/foxy/setup.bash"
            echo "🎉 ROS 2 Foxy installation complete!"
        else
            echo "Invalid selection. Exiting."
            exit 1
        fi
        ;;

    "jammy")
        echo "Starting ROS 2 Humble installation for Ubuntu 22.04..."
        sudo apt install software-properties-common -y
        sudo add-apt-repository universe -y
        sudo apt update && sudo apt install curl -y
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install ros-humble-desktop -y
        sudo apt install ros-dev-tools -y
        
        add_to_bashrc "source /opt/ros/humble/setup.bash"
        echo "🎉 ROS 2 Humble installation complete!"
        ;;

    "noble")
        echo "Starting ROS 2 Jazzy installation for Ubuntu 24.04..."
        sudo apt update &> /dev/null
        sudo apt install -y locales
        sudo locale-gen en_US en_US.UTF-8
        sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
        export LANG=en_US.UTF-8
        
        sudo apt install -y software-properties-common curl
        sudo add-apt-repository universe -y
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
        
        sudo apt update
        sudo apt install -y ros-jazzy-desktop
        sudo apt install -y python3-colcon-common-extensions python3-rosdep
        
        if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rosdep init; fi
        rosdep update
        
        add_to_bashrc "source /opt/ros/jazzy/setup.bash"
        echo "🎉 ROS 2 Jazzy installation complete!"
        ;;

    *)
        echo "ERROR: Unsupported Ubuntu version: $UBUNTU_CODENAME"
        echo "This script supports Bionic (18.04), Focal (20.04), Jammy (22.04), and Noble (24.04)."
        exit 1
        ;;
esac

echo ""
echo "============================================="
echo "IMPORTANT: You must source your .bashrc or open a new terminal"
echo "to activate the ROS environment."
echo "Run: source ~/.bashrc"
echo "============================================="