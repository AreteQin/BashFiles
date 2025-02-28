# Add Docker's official GPG key:
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
# check architecture
if [ $(dpkg --print-architecture) = "amd64" ]; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
elif [ $(dpkg --print-architecture) = "arm64" ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  echo "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
else
  echo "Unsupported architecture"
  exit 1
fi

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add your user to the docker group to run docker without sudo:
sudo usermod -aG docker $USER

echo "Docker has been installed successfully"
echo "==========================================="
echo "Please reboot your system to apply changes"

# wget -qO- https://get.docker.com/ | sh
