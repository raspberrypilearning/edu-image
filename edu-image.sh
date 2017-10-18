#!/bin/sh

echo "Raspi-Config steps"
sudo raspi-config nonint do_camera 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_ssh 0

echo "Updating...."
sleep 2

sudo apt-get -qq update
sudo apt-get -qqy upgrade 
sudo apt-get -qqy dist-upgrade
sudo rpi-update

echo "Installing from apt"
sudo apt-get install -qqy python-numpy python-wxversion python-wxgtk3.0 python-pyparsing python-cairo libhidapi-libusb0 gnome-schedule python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtserialport python3-pyqt5.qtsvg python3-dev

echo "Installing from deb"

echo "Installing from Pip3"
sudo pip3 -q install python-osc explorerhat pibrella piglow requests-oauthlib pyinstaller codebug-i2c-tether codebug-tether
sudo pip -q install explorerhat pibrella piglow requests-oauthlib pyinstaller 

echo "Installing Crumble"
wget -q http://redfernelectronics.co.uk/?ddownload=3869 -O crumble_0.25.1_all.deb
sudo dpkg -i crumble_0.25.1_all.deb 
rm crumble_0.25.1_all.deb

echo "Setting Wallpaper"
wget https://github.com/raspberrypilearning/edu-image/raw/master/Raspbain-Desktop-Background-1366x768px.png
sudo mv Raspbain-Desktop-Background-1366x768px.png /usr/share/rpd-wallpaper/picademy.png
sed -i -e 's/road.jpg/picademy.png/g' .config/pcmanfm/LXDE-pi/desktop-items-0.conf

echo "Installing Mu"
git clone https://github.com/mu-editor/mu.git
cd mu
sudo pip3 install -r requirements_pi.txt
sudo python3 setup.py install
cd ~/

echo "Setting up Resize"
sudo wget -q https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/cmdline.txt -O /boot/cmdline.txt

sudo wget -q https://raw.githubusercontent.com/raspberrypilearning/edu-image/master/resize2fs_once -O /etc/init.d/resize2fs_once
sudo chmod 755 /etc/init.d/resize2fs_once
#sudo ln -s /etc/init.d/resize2fs_once /etc/rc3.d/S01resize2fs_once


echo "Complete, ready to halt. Type 'sudo halt' and then compress image in another machine."

