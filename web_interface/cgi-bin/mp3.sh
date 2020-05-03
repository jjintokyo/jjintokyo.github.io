#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall
sudo vlc2 -I dummy --alsa-audio-device equal -LZ "/home/pi/mp3" </dev/null &>/dev/null &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>MP3 PLAYER</h1>"
echo "<h1>Playing Random MP3...</h1>"
echo "</body>"
echo "</html>"
