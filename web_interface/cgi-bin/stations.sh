#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

cmd1=$(/usr/bin/mpc playlist)
cmd2=$(/bin/hostname)
cmd3=$(/sbin/ifconfig | grep "inet 192.")

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h3><pre>$cmd1</pre></h3>"
echo "<h3>$cmd2</h3>"
echo "<h3>$cmd3</h3>"
echo "</body>"
echo "</html>"
