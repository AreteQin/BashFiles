#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
ROS_DISTRO="jazzy" 
WORKSPACE="$HOME/ros2_${ROS_DISTRO}_ws"

echo "======================================================="
echo " Starting ROS 2 $ROS_DISTRO Source Build on Debian 13  "
echo "======================================================="

# 1. Setup Locale (ROS 2 requires UTF-8)
echo ">>> Setting up locale..."
sudo apt-get update
sudo apt-get install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 2. Install Development Tools and ROS 2 Build System
echo ">>> Installing build tools and Python dependencies..."
sudo apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-pip \
  python3-pytest-cov \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  wget

# 3. Initialize rosdep
echo ">>> Initializing rosdep..."
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi
rosdep update

# 4. Create Workspace and Download Source Code
echo ">>> Creating workspace at $WORKSPACE..."
mkdir -p "$WORKSPACE/src"
cd "$WORKSPACE"

echo ">>> Fetching ROS 2 source code via vcs..."
wget -qO- https://raw.githubusercontent.com/ros2/ros2/${ROS_DISTRO}/ros2.repos | vcs import src

# 5. Install System Dependencies via rosdep
echo ">>> Installing system dependencies..."
# We skip certain DDS keys that can cause issues on pure Debian without specific vendor repos
rosdep install --from-paths src --ignore-src -y \
    --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" \
    --rosdistro "$ROS_DISTRO"

# 6. Compile the Workspace
echo ">>> Compiling the workspace using colcon..."
# Note: if your system freezes during compilation due to RAM limits, 
# you can limit concurrent jobs by adding: --executor sequential
colcon build --symlink-install

# 7. Setup Environment Script
echo "======================================================="
echo " ROS 2 $ROS_DISTRO Installation Complete!              "
echo "======================================================="
echo "To start using ROS 2, source the setup script in your terminal:"
echo "source $WORKSPACE/install/setup.bash"
echo ""
echo "To automatically source it every time you open a new terminal, run:"
echo "echo \"source $WORKSPACE/install/setup.bash\" >> ~/.bashrc"