sudo vim /etc/gdm3/custom.conf

# Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = qin
sudo apt-get install xserver-xorg-video-dummy

sudo vim /etc/X11/xorg.conf

section "Module"
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

## Ubunu 18
cd /usr/lib/systemd/user/graphical-session.target.wants

sudo ln -s ../vino-server.service ./.

gsettings set org.gnome.Vino prompt-enabled false

gsettings set org.gnome.Vino require-encryption false

gsettings set org.gnome.Vino authentication-methods "['vnc']"

gsettings set org.gnome.Vino vnc-password $(echo -n 'nvidia'|base64)

sudo reboot

origin:

Section "Module"
    Disable     "dri"
    SubSection  "extmod"
    Option  "omit xfree86-dga"
    EndSubSection
EndSection

Section "Device"
    Identifier  "Tegra0"
    Driver      "nvidia"
    Option      "AllowEmptyInitialConfiguration" "true"
EndSection
