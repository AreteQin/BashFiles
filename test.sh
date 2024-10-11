#! /bin/bash

codename=$(lsb_release -c | awk '{print $2}')

case $codename in
    "impish")
        echo "Ubuntu 22.04 LTS"
        ;;
    "focal")
        echo "Ubuntu 20.04 LTS"
        ;;
    "bionic")
        echo "Ubuntu 18.04 LTS"
        echo "Not supported!"
        exit
        ;;
esac