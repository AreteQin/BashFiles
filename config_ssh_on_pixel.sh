# 1. Update your package list and install the OpenSSH server
sudo apt update && sudo apt install openssh-server -y

# 2. Change the default port from 22 to 8022 (bypasses Android's port restrictions)
sudo sed -i 's/^#*Port 22/Port 8022/' /etc/ssh/sshd_config

# 3. Enable password authentication (prevents the "publickey" rejection error)
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 4. Restart the SSH background service to apply the configuration changes
sudo systemctl restart ssh

# 5. Set a secure password for the default 'droid' user
sudo passwd droid