#!/bin/bash
#
# This script installs ROS 2 Jazzy Jellyfish (Desktop) on Ubuntu 24.04 (Noble Numbat).
# It follows the official ROS 2 documentation.
#
# Run this script with:
# 1. chmod +x install_ros2_jazzy.sh
# 2. ./install_ros2_jazzy.sh
#

# ---
# 0. Configuration & Safety
# ---
set -e # Exit immediately if a command exits with a non-zero status.

# Verify Ubuntu 24.04 (Noble)
UBUNTU_CODENAME=$(lsb_release -cs)
if [ "$UBUNTU_CODENAME" != "noble" ]; then
    echo "ERROR: This script is intended for Ubuntu 24.04 (Noble Numbat)."
    echo "Your system is: $UBUNTU_CODENAME"
    exit 1
fi

echo "✅ Ubuntu 24.04 (Noble) detected. Proceeding with ROS 2 Jazzy installation..."
echo ""

# ---
# 1. Set Locale
# ---
echo "--- 1/6: Setting locale ---"
sudo apt update &> /dev/null
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
echo "Locale set to en_US.UTF-8."
echo ""

# ---
# 2. Add ROS 2 APT Repository
# ---
echo "--- 2/6: Adding ROS 2 APT repository ---"
# Install prerequisite packages
sudo apt install -y software-properties-common curl

# Add the universe repository
sudo add-apt-repository universe -y

# Add the ROS 2 GPG key
echo "Adding ROS 2 GPG key..."
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Add the repository to sources.list
echo "Adding ROS 2 repository to sources list..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
echo "Repository added."
echo ""

# ---
# 3. Install ROS 2 Packages
# ---
echo "--- 3/6: Installing ROS 2 Jazzy (ros-jazzy-desktop) ---"
sudo apt update
sudo apt install -y ros-jazzy-desktop
echo "ROS 2 Jazzy Desktop installed successfully."
echo ""

# ---
# 4. Install Development Tools (colcon, rosdep)
# ---
echo "--- 4/6: Installing development tools (colcon, rosdep) ---"
sudo apt install -y python3-colcon-common-extensions python3-rosdep
echo "Development tools installed."
echo ""

# ---
# 5. Initialize rosdep
# ---
echo "--- 5/6: Initializing rosdep ---"
# Initialize rosdep (only if it hasn't been initialized)
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi
# Update rosdep
rosdep update
echo "rosdep initialized and updated."
echo ""

# ---
# 6. Set up .bashrc Sourcing
# ---
echo "--- 6/6: Adding ROS 2 sourcing to ~/.bashrc ---"
BASHRC_FILE=~/.bashrc
SOURCE_LINE="source /opt/ros/jazzy/setup.bash"

# Add sourcing to .bashrc only if it's not already there
if ! grep -q -F "$SOURCE_LINE" "$BASHRC_FILE"; then
    echo "" >> "$BASHRC_FILE"
    echo "# Source ROS 2 Jazzy" >> "$BASHRC_FILE"
    echo "$SOURCE_LINE" >> "$BASHRC_FILE"
    echo "Sourcing line added to $BASHRC_FILE."
else
    echo "Sourcing line already exists in $BASHRC_FILE."
fi
echo ""

# ---
# Installation Complete
# ---
echo "🎉 ROS 2 Jazzy installation is complete!"
echo ""
echo "IMPORTANT: You must source your .bashrc or open a new terminal"
echo "to activate the ROS 2 environment."
echo "Run: source ~/.bashrc"