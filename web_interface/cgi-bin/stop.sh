#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Radio stopped...</h1>"
echo "</body>"
echo "</html>"
