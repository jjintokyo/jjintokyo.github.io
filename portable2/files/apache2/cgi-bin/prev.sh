#!/bin/sh

cmd=$(/usr/bin/mpc prev)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
