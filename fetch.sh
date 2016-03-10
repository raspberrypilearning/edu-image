#!/bin/sh
echo "Raspi-Config steps"
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint set_camera 1
sudo raspi-config nonint do_i2c 0

sudo sh -c "printf '@lxterminal -e \"git clone https://github.com/raspberrypilearning/edu-image.git && sudo reboot\"' >> .config/lxsession/LXDE-pi/autostart"
sudo sh -c "printf '@lxterminal -e \"/home/pi/edu-image/edu-install.sh\"' >> .config/lxsession/LXDE-pi/autostart"
sudo sh -c "printf '@lxterminal -e \"sed sh -c "printf '@lxterminal -e \"-i '/https://github.com/raspberrypilearning/edu-image.git/d' /home/pi/.config/lxsession/LXDE-pi/autostart\"' >> .config/lxsession/LXDE-pi/autostart"
sudo sh -c "printf 'hdmi_group=2' >> /boot/config.txt"
sudo sh -c "printf 'hdmi_mode=86' >> /boot/config.txt"
git clone https://github.com/raspberrypilearning/edu-image.git
read

chmod 755 /home/pi/edu-image/edu-install.sh
sudo mv /home/pi/edu-image/mu.desktop /usr/share/applications
sudo chmod u+x /home/pi/edu-image/vncserver.service
sudo chown root:root /home/pi/edu-image/vncserver.service

sudo mv /home/pi/edu-image/vncserver.service /lib/systemd/system/

sudo ln -s /lib/systemd/system/vncserver.service /etc/systemd/system/vncserver.service

sudo systemctl enable vncserver

echo "Ready to Reboot"
read
sleep 10
sudo reboot

