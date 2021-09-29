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

