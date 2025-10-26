#!/bin/sh

cmd1=$(/root/my_radio/random_run.sh)
cmd2=$(/usr/bin/mpc status)

/bin/echo $cmd1 | /usr/bin/tee /tmp/url1.txt > /dev/null

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<font size=4 color=Blue>"
echo "<b>$cmd1</b><br>"
echo "<font color=Black>"
echo "<h3><pre>$cmd2</pre></h3>"
echo "</body>"
echo "</html>"
