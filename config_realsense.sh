sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt install librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg -y

# for ARM
# sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
# sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo bionic main" -u
# sudo apt-get install librealsense2-utils -y
# sudo apt-get install librealsense2-dev -y
# sudo apt-get install librealsense2-dbg -y
# sudo apt-get install librealsense2-dkms -y