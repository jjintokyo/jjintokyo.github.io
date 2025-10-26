#!/bin/sh

cmd1=$(/usr/bin/mpc)
cmd2=$(/sbin/ifconfig wlan0 | /bin/grep 'inet addr:' | /usr/bin/cut -d: -f2 | /usr/bin/awk '{ print $1 }')
cmd3=$(/sbin/ifconfig eth0.1 | /bin/grep 'inet addr:' | /usr/bin/cut -d: -f2 | /usr/bin/awk '{ print $1 }')
cmd4=$(/usr/bin/mpc current -f %file%)

if [ "$cmd4" != "" ]; then /bin/echo $cmd4 | /usr/bin/tee /tmp/url1.txt > /dev/null; fi

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<h3><pre>$cmd1</pre></h3>"
echo "<font size=3 color=Blue>"
echo "<b>ifconfig wlan0 = $cmd2</b><br>"
echo "<b>ifconfig eth0 = $cmd3</b>"
echo "</body>"
echo "</html>"
