git config --global user.name "qin"
git config --global user.email "qinqiaomeng@outlook.com"
ssh-keygen -t rsa -C "qinqiaomeng@outlook.com"
cd ~/.ssh && cat id_rsa.pub

## Now, go to 
## https://github.com/settings/keys
## and add the SSH key