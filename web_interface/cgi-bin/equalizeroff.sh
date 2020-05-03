#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

cmd=$(sudo /home/pi/presets)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Equalizer OFF</h1>"
echo "<FONT SIZE=3 COLOR=Black>"
echo "<pre>$cmd</pre>"
echo "</body>"
echo "</html>"
