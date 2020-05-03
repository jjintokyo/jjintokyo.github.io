#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

if [ -z ${QUERY_STRING} ]; then
    cmd=$(/usr/bin/mpc play)
else
    cmd=$(/usr/bin/mpc play "${QUERY_STRING}")
fi

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h3><pre>$cmd</pre></h3>"
echo "</body>"
echo "</html>"
