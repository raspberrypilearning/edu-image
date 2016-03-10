set -e
sudo sed '/git clone/d' /etc/rc.local
sleep 5
echo "Updating"

sudo apt-get update
sudo apt-get -y upgrade 
sudo apt-get -y dist-upgrade
sudo rpi-update

echo "Installing from apt"
sudo apt-get install -y python3-twython tightvncserver python3-smbus vim python-twython python-smbus python-flask python3-flask python-picraft python3-picraft python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtserialport gnome-schedule

echo "Installing from Pip3"
sudo pip3 install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller
sudo pip install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller

mkdir /opt/mu
cd /opt/mu
sudo wget https://s3-us-west-2.amazonaws.com/ardublockly-builds/microbit/raspberry_pi/mu-2016-02-16_21_33_00 -O mu
sudo chmod 755 mu

echo "VNC Setup"


sudo raspi-config nonint set_camera 1
sudo raspi-config nonint do_i2c 0

sudo sh -c "printf 'hdmi_group=2' >> /boot/config.txt"
sudo sh -c "printf 'hdmi_mode=86' >> /boot/config.txt"


sudo mv /home/pi/edu-image/mu.desktop /usr/share/applications
sudo chmod u+x /home/pi/edu-image/vncserver.service
sudo chown root:root /home/pi/edu-image/vncserver.service
sudo mv /home/pi/edu-image/vncserver.service /lib/systemd/system/
sudo ln -s /lib/systemd/system/vncserver.service /etc/systemd/system/vncserver.service
sudo systemctl enable vncserver

tightvncserver

echo "Tidying up"
sudo sed '/edu-install/d' /etc/rc.local

sudo raspi-config nonint do_wait_for_network Fast
sudo raspi-config nonint do_boot_behaviour Desktop

rm -rf /home/pi/edu-image
echo "ALL DONE!"
echo "Ready to Reboot"

#sudo reboot
