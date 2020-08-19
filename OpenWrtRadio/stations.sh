#!/bin/sh

### cmd=$(cat /root/playlist.db)
cmd=$(/usr/bin/mpc playlist)

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
