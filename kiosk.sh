#!/bin/bash
#export DISPLAY=:0.0

# xset s noblank
# xset s off
# xset -dpms

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

/usr/bin/node /home/pi/cardservice/app.js &
/usr/bin/chromium-browser --disk-cache-dir=/dev/null --disk-cache-size=1 --noerrdialogs --disable-infobars --kiosk http://10.0.11.32:8081/EsoWebClient/ &

# while true; do
#       xdotool search --onlyvisible --class Chromium windowfocus
#       xdotool keydown ctrl+r; xdotool keyup ctrl+r;
#       sleep 600
# done
