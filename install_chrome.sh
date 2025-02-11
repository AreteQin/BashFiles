#!/bin/bash

# Check the system architecture
architecture=$(uname -m)

echo "System Architecture: $architecture"

# Install Chrome or Chromium based on architecture
if [[ "$architecture" == "x86_64" ]]; then
    echo "Installing Chrome (x86/x64)..."

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt update
    sudo apt install google-chrome-stable -y

    if [[ $? -eq 0 ]]; then
        echo "Chrome installation successful!"
    else
        echo "Chrome installation failed."
    fi

elif [[ "$architecture" == "aarch64" || "$architecture" == "armv7l" || "$architecture" == "armv8l" ]]; then # Added more ARM architectures
    echo "Installing Chromium (ARM)..."

    sudo apt-get update
    sudo apt-get install -y chromium-browser

    if [[ $? -eq 0 ]]; then
        echo "Chromium installation successful!"
    else
        echo "Chromium installation failed."
    fi

else
    echo "Unsupported architecture: $architecture"
    echo "Cannot install Chrome or Chromium."
fi
