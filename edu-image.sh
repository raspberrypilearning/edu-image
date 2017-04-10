#!/bin/sh
wget https://github.com/raspberrypilearning/edu-image/blob/master/thonny_0.1_all.deb
wget https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/cmdline.txt
wget https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/resize2fs_once

echo "pause"
read x


echo "Raspi-Config steps"
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_vnc 0

echo "Updating...."
sleep 2

sudo apt-get update
sudo apt-get -y upgrade 
sudo apt-get -y dist-upgrade
sudo rpi-update

echo "pause"
read x

echo "Installing from apt"
sudo apt-get install -y vim python3-codebug-i2c-tether python3-codebug-tether mu gnome-schedule

echo "Installing from deb"
sudo dpkg -i thonny_0.1_all.deb

echo "pause"
read x


echo "Installing from Pip3"
sudo pip3 install explorerhat pibrella piglow requests-oauthlib pyinstaller python-sonic pyflakes pep8
sudo pip install explorerhat pibrella piglow requests-oauthlib pyinstaller 

echo "Installing Mu"
git clone https://github.com/mu-editor/mu.git
sudo rm -rf /usr/lib/python3/dist-packages/mu/*
sudo cp -R ~/mu/mu/* /usr/lib/python3/dist-packages/mu/

echo "pause"
read x


echo "Installing Crumble"
wget http://redfernelectronics.co.uk/?ddownload=3869 -O crumble_0.25.1_all.deb
sudo apt-get install -y python-numpy python-wxversion libwxbase3.0-0 libwxgtk3.0-0 python-wxgtk3.0 python-pyparsing python-cairo libhidapi-libusb0
sudo dpkg -i crumble_0.25.1_all.deb 
rm crumble_0.25.1_all.deb

## UNTESTED - PLEASE TEST THIS
## make a dir and mount the boot partition
sudo mkdir /home/pi/boot_part
sudo mount /dev/mmcblk0p1 /home/pi/boot_part
## copy cmdline.txt to boot parttition
sudo mv cmdline.txt /home/pi/boot_part/.

##unount and remove the dir
sudo umount /home/pi/boot_part
sudo rm -r /home/pi/boot_part

sudo mv resize2fs_once /etc/init.d/
sudo ln -s /etc/init.d/resize2fs_once /etc/rc3.d/S01resize2fs_once

echo "Complete, ready to halt"
echo "pause"
read x

