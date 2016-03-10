set -e

echo "Updating"
sleep 10

sudo apt-get update
sudo apt-get -y upgrade 
sudo apt-get -y dist-upgrade
sudo rpi-update
read
echo "Installing from apt"
sudo apt-get install -y python3-twython tightvncserver python3-smbus vim python-twython python-smbus python-flask python3-flask python-picraft python3-picraft python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtserialport gnome-schedule

read
echo "Installing from Pip3"
sudo pip3 install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller
sudo pip install explorerhat pibrella piglow picraft requests-oauthlib pyinstaller

read
mkdir /opt/mu
cd /opt/mu
sudo wget https://s3-us-west-2.amazonaws.com/ardublockly-builds/microbit/raspberry_pi/mu-2016-02-16_21_33_00 -O mu
sudo chmod 755 mu

echo "VNC Setup"

sed -i '/edu-install/d' /home/pi/.config/lxsession/LXDE-pi/autostart
tightvncserver
rm edu-install.sh
echo "ALL DONE!"
