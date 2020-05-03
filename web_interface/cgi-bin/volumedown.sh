#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

# /usr/bin/mpc volume -3

cmd=$(sudo amixer -c 0 set PCM 3dB-)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Volume -</h1>"
echo "<FONT SIZE=3 COLOR=Black>"
echo "<pre>$cmd</pre>"
echo "</body>"
echo "</html>"
