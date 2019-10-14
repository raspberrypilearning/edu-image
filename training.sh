#!/bin/sh

echo "Raspi-Config steps"
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_ssh 0
echo "AUGUST"
echo "Updating...."
sleep 2

#echo 'deb http://plugwash.raspbian.org/sonic-pi buster-sonicpi main ' | sudo tee -a /etc/apt/sources.list


sudo apt-get -qq update
sudo apt-get -qq purge wolfram-engine wolframscript geany scratch scratch2
sudo apt-get -qqy upgrade 
sudo apt-get -qqy dist-upgrade

echo "Installing from apt"
sudo apt install -qqy  scratch3 sonic-pi sonic-pi-server sonic-pi-samples mu-editor ffmpeg
echo "Installing from pip3"
sudo pip3 -q install pigps bluedot guizero twython python-osc explorerhat pibrella piglow requests-oauthlib pyinstaller codebug-i2c-tether codebug-tether --upgrade
sudo pip -q install explorerhat pibrella piglow requests-oauthlib pyinstaller 

#echo "Installing Crumble"
#wget -q http://redfernelectronics.co.uk/?ddownload=3869 -O crumble_0.25.1_all.deb
#sudo apt-get install -qqy python-wxversion libwxbase3.0-0v5 libwxgtk3.0-0v5 python-wxgtk3.0 python-pyparsing libhidapi-libusb0
#sudo dpkg -i crumble_0.25.1_all.deb 
#rm crumble_0.25.1_all.deb

echo "Setting Wallpaper"
desktop_background=https://github.com/raspberrypilearning/edu-image/raw/master/Raspbian-Desktop-Background-1366x768px.png
sudo wget $desktop_background -O /usr/share/rpd-wallpaper/picademy.png
cp /usr/share/applications/ sonic-pi.desktop ~/Desktop/
cp /usr/share/applications/ mu.codewith.editor.desktop ~/Desktop/
cp /usr/share/applications/ scratch3.desktop ~/Desktop/
mkdir -p /home/pi/.config/pcmanfm/LXDE-pi/
cp /etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf /home/pi/.config/pcmanfm/LXDE-pi/
sed -i -e 's/temple.jpg/picademy.png/g' /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
sed -i -e 's/mounts=0/mounts=1/g' /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf

#echo "Setting up Resize"
sudo wget -q https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/cmdline.txt -O /boot/cmdline.txt
sudo wget -O /etc/init.d/resize2fs_once https://raw.githubusercontent.com/RPi-Distro/pi-gen/master/stage2/01-sys-tweaks/files/resize2fs_once
sudo chmod +x /etc/init.d/resize2fs_once
sudo systemctl enable resize2fs_once


echo "Complete, ready to halt. Type 'sudo halt' and then, if cloning, compress image in another machine."
