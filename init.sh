#!/bin/sh
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint do_wait_for_network Slow
sudo raspi-config nonint do_boot_behaviour Console
sed -i -e '$i \echo "test complete"' /etc/rc.local
