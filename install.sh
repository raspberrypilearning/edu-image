#!/bin/sh
echo "Raspi-Config steps"
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint set_camera 1
sudo raspi-config nonint do_i2c 0

sudo sh -c "printf '@lxterminal -e \"/home/pi/edu-install.sh\"' >> .config/lxsession/LXDE-pi/autostart"

cat > /home/pi/edu-install.sh << EOL
set -e


echo "Updating"
sleep 5

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

cat > vncserver.service << EOL

[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Exec=/usr/bin/python3 /opt/mu/run.py
Icon=/opt/mu/conf/mu.png
Terminal=false
Name=Mu for Microbit
Comment=A micro Python editor
Categories=Application;Development;Qt;
EOL


echo "VNC Setup"

sed -i '/edu-install/d' /home/pi/.config/lxsession/LXDE-pi/autostart
tightvncserver
rm edu-install.sh

EOL

chmod 755 edu-install.sh

cat > vncserver.service << EOL
[Unit]
Description=Remote desktop service (VNC)
After=rsyslog.service network.target

[Service]
Type=simple
RemainAfterExit=yes
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/sbin/runuser -l pi -c "/usr/bin/vncserver -geometry 1024x768 %i"
ExecStop=/sbin/runuser -l pi -c "/usr/bin/vncserver -kill %i"

[Install]
WantedBy=multi-user.target
EOL



echo "enable..."
sudo chmod u+x vncserver.service

sudo chown root:root vncserver.service
sudo mv vncserver.service /lib/systemd/system/

sudo ln -s /lib/systemd/system/vncserver.service /etc/systemd/system/vncserver.service

sudo systemctl enable vncserver

sudo reboot
