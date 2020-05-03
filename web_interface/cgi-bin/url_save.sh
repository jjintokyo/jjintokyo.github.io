#!/bin/bash

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

read POST_STRING
IFS='&' read -r -a array <<< "${POST_STRING}"

for ((i = 0; i <= 40; i++)); do

q="${array[$i]}"
nb="${q%=*}"
url="${q#*=}"
decoded_url=$(echo -e "${url//%/\\x}")

if [ "$i" -eq 0 ]; then
				echo $decoded_url | sudo tee /home/pi/temp/playlist.db > /dev/null
elif [ "$i" -eq 40 ]; then
				echo $decoded_url | sudo tee /home/pi/temp/special.db > /dev/null
else
				echo $decoded_url | sudo tee -a /home/pi/temp/playlist.db > /dev/null
fi

done

/usr/bin/mpc clear &>/dev/null
cat /home/pi/temp/playlist.db | /usr/bin/mpc add
cmd=$(/usr/bin/mpc playlist)
special=$(cat /home/pi/temp/special.db)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR='Lavender' TEXT='Black'>"
echo "<FONT SIZE='5' COLOR='DarkBlue'>"
echo "<B>URLs Saved!</B>"
echo "<BR>"
echo "<FONT SIZE='3' COLOR='Black'>"
echo "<pre>$cmd</pre>"
echo "<pre>$special</pre>"
echo "</body>"
echo "</html>"
