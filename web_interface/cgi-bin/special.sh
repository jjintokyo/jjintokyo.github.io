#!/bin/bash

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

url=$(cat /home/pi/temp/special.db)
echo $url | sudo tee /home/pi/temp/url > /dev/null
sudo vlc2 -I dummy --alsa-audio-device equal $url </dev/null &>/dev/null &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<FONT SIZE=3 COLOR=DarkBlue>"
echo "<B>$url</B>"
echo "</body>"
echo "</html>"
