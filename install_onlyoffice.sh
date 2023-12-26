## Method 1
# cd ~
# sudo apt  install curl -y
# sudo apt-get install postgresql -y
# sudo -i -u postgres psql -c "CREATE USER onlyoffice WITH PASSWORD 'onlyoffice';"
# sudo -i -u postgres psql -c "CREATE DATABASE onlyoffice OWNER onlyoffice;"
# sudo apt-get install rabbitmq-server -y
# echo onlyoffice-documentserver onlyoffice/ds-port select 80 | sudo debconf-set-selections
# mkdir -p -m 700 ~/.gnupg
# curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --import
# chmod 644 /tmp/onlyoffice.gpg
# sudo chown root:root /tmp/onlyoffice.gpg
# sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg
# echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
# sudo apt-get update -y
# # Install mscorefonts:
# sudo apt-get install ttf-mscorefonts-installer -y
# echo "3:"
# # Install ONLYOFFICE Docs
# sudo apt-get install onlyoffice-documentserver -y
# sudo systemctl start ds-example
# sudo systemctl enable ds-example

## Method 2: https://helpcenter.onlyoffice.com/installation/docs-community-install-from-snap.aspx?_ga=2.24912700.782359554.1594636128-1157782750.1587541027
sudo apt install snapd

## Now you can enter http://localhost to open it.

## Method 3: https://helpcenter.onlyoffice.com/installation/docs-community-install-script.aspx