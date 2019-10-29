#!/bin/sh

echo "Raspi-Config steps"
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_ssh 0
echo "AUGUST"
echo "Updating...."
sleep 2

sudo apt-get -qq update
sudo apt-get -qq purge wolfram-engine wolframscript geany scratch scratch2
sudo apt-get -qqy upgrade 
sudo apt-get -qqy dist-upgrade

echo "Installing from apt"
sudo apt install -qqy  scratch3 sonic-pi sonic-pi-server sonic-pi-samples mu-editor
echo "Installing from pip3"
sudo pip3 -q install bluedot guizero twython python-osc explorerhat --upgrade

echo "Setting Wallpaper"
desktop_background=https://github.com/raspberrypilearning/edu-image/raw/master/bytes.png
sudo wget $desktop_background -O /usr/share/rpd-wallpaper/bytes.png
cp /usr/share/applications/sonic-pi.desktop /home/pi/Desktop/
cp /usr/share/applications/mu.codewith.editor.desktop /home/pi/Desktop/
cp /usr/share/applications/scratch3.desktop /home/pi/Desktop/
mkdir -p /home/pi/.config/pcmanfm/LXDE-pi/
cp /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf /home/pi/.config/pcmanfm/LXDE-pi/
sed -i -e 's/temple.jpg/bytes.png/g' /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
sed -i -e 's/mounts=0/mounts=1/g' /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf

echo "Adding Resources"
resources=https://github.com/raspberrypilearning/edu-image/raw/master/bytes-resources.zip
wget $resources -O ~/Desktop/resources.zip
unzip ~/Desktop/resources.zip -d ~/Desktop
rm ~/Desktop/resources.zip

#echo "Setting up Resize"
sudo wget -q https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/cmdline.txt -O /boot/cmdline.txt
sudo wget -O /etc/init.d/resize2fs_once https://raw.githubusercontent.com/RPi-Distro/pi-gen/master/stage2/01-sys-tweaks/files/resize2fs_once
sudo chmod +x /etc/init.d/resize2fs_once
sudo systemctl enable resize2fs_once


echo "Complete, ready to halt. Type 'sudo halt' and then, if cloning, compress image in another machine."
