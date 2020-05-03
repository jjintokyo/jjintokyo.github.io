#!/bin/bash

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

i="${QUERY_STRING}"
read POST_STRING
IFS='&' read -r -a array <<< "${POST_STRING}"
q="${array[$i]}"
nb="${q%=*}"
url="${q#*=}"

### decoded_url=$(echo -e `echo $url | sed 's/+/ /g;s/%/\\\\x/g;'`)
decoded_url=$(echo -e "${url//%/\\x}")
sudo vlc2 -I dummy --alsa-audio-device equal $decoded_url </dev/null &>/dev/null &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR='Lavender' TEXT='Black'>"
echo "<FONT SIZE='4' COLOR='DarkBlue'>"
echo "<B>Playing URL $nb...</B>"
echo "<BR><BR>"
echo "<FONT SIZE='3' COLOR='Black'>"
echo "<B>$decoded_url</B>"
echo "<BR><BR>"
echo "<img src='/dancingalien.gif' alt='dancing alien' BORDER='0'>"
echo "</body>"
echo "</html>"
