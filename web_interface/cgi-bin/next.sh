#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

cmd=$(/usr/bin/mpc next)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
