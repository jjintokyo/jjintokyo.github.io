#!/bin/bash

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

eval $(echo ${QUERY_STRING//&/;})

IFS=$'\n' read -d '' -r -a lines < /home/pi/temp/playlist.db
i=$((10#"$mySelection2"-1))
url="${lines[$i]}"

echo $url | sudo tee /home/pi/temp/url > /dev/null

sudo vlc2 -I dummy --alsa-audio-device equal $url </dev/null &>/dev/null &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<FONT SIZE=3 COLOR=DarkBlue>"
echo "<B>$mySelection2 = $url</B>"
echo "</body>"
echo "</html>"
