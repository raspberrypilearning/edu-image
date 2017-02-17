#!/bin/sh
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

echo "Installing from apt"
sudo apt-get install -y vim python3-codebug-i2c-tether python3-codebug-tether mu gnome-schedule


echo "Installing from Pip3"
sudo pip3 install explorerhat pibrella piglow requests-oauthlib pyinstaller python-sonic pyflakes pep8
sudo pip install explorerhat pibrella piglow requests-oauthlib pyinstaller 

git clone https://github.com/mu-editor/mu.git
sudo rm -rf /usr/lib/python3/dist-packages/mu/*
sudo cp -R ~/mu/mu/* /usr/lib/python3/dist-packages/mu/
