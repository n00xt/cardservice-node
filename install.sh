#!/bin/bash

sudo systemctl stop kiosk.service && sudo systemctl disable kiosk.service
sudo rm /lib/systemd/system/kiosk.service
sudo apt update && sudo apt upgrade -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn sed snmp snmpd snmp-mibs-downloader
cd /home/pi/cardservice/ && yarn install

sudo mv /home/pi/cardservice/kiosk.service /lib/systemd/system/kiosk.service
chmod +x /home/pi/cardservice/kiosk.sh

#sudo daemon-reload
sudo systemctl start kiosk.service && sudo systemctl enable kiosk.service

sudo sed -i 's/mibs :/#mibs :/' /etc/snmp/snmp.conf
sudo sed -i 's/agentAddress  udp:127.0.0.1:161/agentAddress udp:161/' /etc/snmp/snmpd.conf
sudo sed -i 's/#rocommunity public  localhost/rocommunity public/' /etc/snmp/snmpd.conf


sed -i 's/"orphan_rows_removed":true/"credit_card_enabled":false,"orphan_rows_removed":true,"profile_enabled":false/' /home/pi/.config/chromium/Default/Preferences

sed -i 's/"browser":{/"browser":{"clear_data":{"form_data":true,"hosted_apps_data":true,"passwords":true,"site_settings":true},/' /home/pi/.config/chromium/Default/Preferences

sed -i 's/"data_reduction"/"credentials_enable_autosignin":false,"credentials_enable_service":false,"data_reduction"/' /home/pi/.config/chromium/Default/Preferences

mkdir /home/pi/cardservice/logs
touch /home/pi/cardservice/logs/cronlog
chmod +x /home/pi/cardservice/update.sh

sudo /bin/bash -c 'echo "0 0 * * 0 /sbin/shutdown -r now" >> /etc/crontab'
sudo /bin/bash -c 'echo "30 1 * * 0 sh /home/pi/cardservice/update.sh 2>/home/pi/logs/cronlog" >> /etc/crontab'

#sudo crontab -e
#0 0 * * 0 /sbin/shutdown -r now
#30 1 * * 0 sh /home/pi/cardservice/update.sh 2>/home/pi/logs/cronlog
