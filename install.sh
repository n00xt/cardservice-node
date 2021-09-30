#!/bin/bash

sudo apt update && sudo apt upgrade -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn sed
cd /home/pi/cardservice/ && yarn install

mv /home/pi/cardservice/kiosk.service /lib/systemd/system/kiosk.service
chmod +x /home/pi/cardservice/kiosk.sh

sed -i 's/"orphan_rows_removed":true/"credit_card_enabled":false,"orphan_rows_removed":true,"profile_enabled":false/' /home/pi/.config/chromium/Default/Preferences

sed -i 's/"browser":{/"browser":{"clear_data":{"form_data":true,"hosted_apps_data":true,"passwords":true,"site_settings":true},/' /home/pi/.config/chromium/Default/Preferences

sed -i 's/"data_reduction"/"credentials_enable_autosignin":false,"credentials_enable_service":false,"data_reduction"/' /home/pi/.config/chromium/Default/Preferences

mkdir logs
touch ./logs/cronlog
chmod +x /home/pi/cardservice/update.sh

#sudo crontab -e
#0 0 * * 0 /sbin/shutdown -r now
#30 1 * * 0 sh /home/pi/cardservice/update.sh 2>/home/pi/logs/cronlog
