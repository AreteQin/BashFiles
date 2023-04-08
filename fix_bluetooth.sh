# cd ~
# mkdir Bluetooth
# cd Bluetooth
# wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761b_config
# wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761b_fw

# sudo mv rtl8761b_config /usr/lib/firmware/rtl_bt/rtl8761b_config.bin
# sudo mv rtl8761b_fw /usr/lib/firmware/rtl_bt/rtl8761b_fw.bin

cd /lib/firmware/rtl_bt
sudo ln -s rtl8761b_config.bin rtl8761bu_config.bin
sudo ln -s rtl8761b_fw.bin rtl8761bu_fw.bin