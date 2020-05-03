#!/bin/bash

url=$(cat /home/pi/temp/url)

details=$(sudo /home/pi/icecast_play/get_the_stream_title.py $url 2>&1)

url2=$(cat /home/pi/temp/url2)

# detail1="$(sudo /home/pi/icecast_play/get_the_stream_title.py $url)"
# detail2="$(sudo /home/pi/icecast_play/get_the_stream_title.py $url 2>&1 > /dev/null)"

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<FONT SIZE=3 COLOR=DarkBlue>"
echo "<B>$url</B>"
echo "<BR><BR>"
echo "<FONT SIZE=3 COLOR=Black>"
echo "<B>$url2</B>"
echo "<pre>$details</pre>"
echo "</body>"
echo "</html>"
