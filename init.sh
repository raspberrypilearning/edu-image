#!/bin/sh
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint do_wait_for_network Slow
sudo raspi-config nonint do_boot_behaviour Console
sudo sed -i -e '$i \cd /home/pi && su pi -c "git clone https://github.com/raspberrypilearning/edu-image.git"' /etc/rc.local
sudo sed -i -e '$i \cd edu-image && su pi -c "/usr/bin/sh edu-install.sh"' /etc/rc.local

