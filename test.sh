echo "============================================="
echo "Press any key to continue..."
read -n 1 -s

sudo echo 'Section "Module"
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
EndSection' > xorg.conf