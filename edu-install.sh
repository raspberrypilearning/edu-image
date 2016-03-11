set -e
echo "Configuring Edu Image"
echo "====================="
sleep 5

sudo sh -c "printf '\nhdmi_group=2\n' >> /boot/config.txt"
sudo sh -c "printf 'hdmi_mode=86\n' >> /boot/config.txt"
sudo raspi-config nonint set_camera 1
sudo raspi-config nonint do_i2c 0
sudo sed -i '/git clone/d' /etc/rc.local

echo "Updating"
echo "========"
sleep 5

sudo apt-get update
sudo apt-get -y upgrade 
sudo apt-get -y dist-upgrade
sudo rpi-update

echo "Installing from apt"
echo "==================="
sleep 5

sudo apt-get install -y python3-twython tightvncserver python3-smbus vim python-twython python-smbus python-flask python3-flask python-picraft python3-picraft python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtserialport gnome-schedule

echo "Installing from Pip3"
echo "===================="
sleep 5
sudo pip3 install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller
sudo pip install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller

echo "Installing Mu"
echo "============="
sleep 5
cd /opt/
sudo git clone https://github.com/ntoll/mu.git
sudo chmod 755 mu
sudo mv /home/pi/edu-image/mu.desktop /usr/share/applications

echo "Configuring VNC"
echo "================="
sleep 5
sudo chmod u+x /home/pi/edu-image/vncserver.service
sudo chown root:root /home/pi/edu-image/vncserver.service
sudo mv /home/pi/edu-image/vncserver.service /lib/systemd/system/
sudo ln -s /lib/systemd/system/vncserver.service /etc/systemd/system/vncserver.service
sudo systemctl enable vncserver

echo "Tidying up"
echo "=========="
sudo sed -i '/edu-install/d' /etc/rc.local
sudo sed -i '/sleep/d' /etc/rc.local
sudo raspi-config nonint do_wait_for_network Fast
sudo raspi-config nonint do_boot_behaviour Desktop

rm -rf /home/pi/edu-image
echo "ALL DONE!"
echo "The final step is to set a vnc password and then reboot (you do not need a view only password)

tightvncserver
