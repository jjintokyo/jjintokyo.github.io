#!/bin/sh

cmd1=$(/usr/bin/mpc)
cmd2=$(/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
cmd3=$(/sbin/ifconfig br-lan | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h3><pre>$cmd1</pre></h3>"
echo "<FONT SIZE=3 COLOR=Blue>"
echo "<b>ifconfig wlan0 = $cmd2</b><BR>"
echo "<b>ifconfig eth0 = $cmd3</b>"
echo "</body>"
echo "</html>"
