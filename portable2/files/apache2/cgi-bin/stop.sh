#!/bin/sh

cmd=$(/usr/bin/mpc stop)

sudo /usr/bin/killall -q mpg123

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<h1>Radio stopped...</h1>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
