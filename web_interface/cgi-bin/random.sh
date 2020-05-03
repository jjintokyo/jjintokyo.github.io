#!/bin/bash

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

eval $(echo ${QUERY_STRING//&/;})

if [ "$mySelection" = "Everything" ]; then
    url=$(sudo /home/pi/icecast_play/icecast_http.py)
else
    url=$(sudo /home/pi/icecast_play/icecast_http.py "$mySelection")
fi

echo $url | sudo tee /home/pi/temp/url > /dev/null

sudo vlc2 -I dummy --alsa-audio-device equal $url </dev/null &>/dev/null &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<table border='0'>"
echo "<TR>"
echo "<td align='left'>"
echo "<FONT SIZE=3 COLOR=Black>"
echo "Random Web Radio..... <B>$mySelection</B>"
echo "</td>"
echo "<td width='10%' rowspan='2'>"
echo "</td>"
echo "<td rowspan='2' align='right'>"
echo "<img src='/dancingalien.gif' alt='dancing alien' BORDER=0>"
echo "</td>"
echo "</tr>"
echo "<TR>"
echo "<td align='left'>"
echo "<FONT SIZE=3 COLOR=DarkBlue>"
echo "<B>$url</B>"
echo "</td>"
echo "</tr>"
echo "</table>"
echo "</body>"
echo "</html>"
