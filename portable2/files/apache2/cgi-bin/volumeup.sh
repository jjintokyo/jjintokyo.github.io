#!/bin/sh

cmd=$(/usr/bin/amixer sset 'Speaker' 5%+)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<h1>Volume +</h1>"
echo "<font size=2 color=Black>"
echo "<pre>$cmd</pre>"
echo "</body>"
echo "</html>"
