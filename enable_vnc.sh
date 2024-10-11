# Enabling automatic login
echo "Modify the following in your /etc/gdm3/custom.conf file according to your [username]"
echo "============================================="
echo "AutomaticLoginEnable = true"
echo "AutomaticLogin = qin"
echo "============================================="
echo "Press any key to continue..."
read -n 1 -s

sudo vim /etc/gdm3/custom.conf

sudo apt install vino xserver-xorg-video-dummy -y

echo "============================================"
echo "Set a password for screen sharing！"
echo "Press any key to continue..."
read -n 1 -s

gsettings set org.gnome.Vino require-encryption false

cat << EOF
============================================
Replace orignal content with the following in your /etc/X11/xorg.conf file
============================================
Section "Module"
        Disable "dri"
        SubSection "extmod"
                Option "Omit xfree86-dga"
        EndSubSection
EndSection

Section "Device"
    Identifier  "Configured Video Device"
    Driver      "dummy"
    # Default is 4MiB, this sets it to 16MiB
    VideoRam    16384
EndSection

Section "Monitor"
    Identifier  "Configured Monitor"
    HorizSync 31.5-48.5
    VertRefresh 50-70
EndSection

Section "Screen"
    Identifier  "Default Screen"
    Monitor     "Configured Monitor"
    Device      "Configured Video Device"
    DefaultDepth 24
    SubSection "Display"
    Depth 24
    Modes "1024x800"
    EndSubSection
EndSection
============================================
Press any key to continue...
EOF

read -n 1 -s

sudo vim /etc/X11/xorg.conf

echo "============================================"
echo "Now you can use VNC viewer to connect to your Ubuntu!"