#!/bin/bash

i="${QUERY_STRING}"
read POST_STRING
IFS='&' read -r -a array <<< "${POST_STRING}"
q="${array[$i]}"
nb="${q%=*}"
url="${q#*=}"

### decoded_url=$(echo -e `echo $url | sed 's/+/ /g;s/%/\\\\x/g;'`)
decoded_url=$(echo -e "${url//%/\\x}")
check=$(sudo /home/pi/icecast_play/get_the_stream_title.py $decoded_url 2>&1)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR='Lavender' TEXT='Black'>"
echo "<FONT SIZE='4' COLOR='DarkBlue'>"
echo "<B>Checking URL $nb...</B>"
echo "<BR><BR>"
echo "<img src='/yes.gif' alt='yes' BORDER='0'>"
echo "<BR>"
echo "<FONT SIZE='3' COLOR='Black'>"
echo "<pre>$check</pre>"
echo "</body>"
echo "</html>"
