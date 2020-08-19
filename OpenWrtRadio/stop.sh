#!/bin/sh

cmd=$(/usr/bin/mpc stop)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Radio stopped...</h1>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
