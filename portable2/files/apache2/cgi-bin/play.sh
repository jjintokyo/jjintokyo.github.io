#!/bin/sh

if [ -z ${QUERY_STRING} ]; then
    cmd=$(/usr/bin/mpc play)
else
    cmd=$(/usr/bin/mpc play "${QUERY_STRING}")
fi

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body bgcolor=Lavender text=Black>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
