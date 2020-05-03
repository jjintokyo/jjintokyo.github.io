#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

cmd=$(sudo /home/pi/presets jj)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Equalizer ON</h1>"
echo "<FONT SIZE=3 COLOR=Black>"
echo "<pre>$cmd</pre>"
echo "</body>"
echo "</html>"
