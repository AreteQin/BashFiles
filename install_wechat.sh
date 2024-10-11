# cd ~/Downloads
# wget http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.4_amd64.deb
# sudo dpkg -i weixin*.deb

echo "============================================="
echo "Installing WeChat, choose platform"
echo "(1) Ubuntu 20"
echo "(2) Ubuntu 22"
read system

case ${system} in
    "1")
        # wget -c -O atzlinux-v11-archive-keyring_lastest_all.deb https://www.atzlinux.com/atzlinux/pool/main/a/atzlinux-archive-keyring/atzlinux-v11-archive-keyring_lastest_all.deb
        # sudo apt -y install ./atzlinux-v11-archive-keyring_lastest_all.deb
        # sudo apt update
        # sudo apt install atzlinux-store-a11 -y
        cd ~/Downloads
        wget http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.4_amd64.deb
        sudo dpkg -i weixin*.deb
        ;;
    "2")
        echo "Ubuntu 22 not tested yet"
        ;;
esac

echo "============================================="
echo "WeChat installed!"