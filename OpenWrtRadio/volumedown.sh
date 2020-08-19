#!/bin/sh

cmd=$(sudo /usr/bin/amixer sset 'Speaker' 5%-)

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Volume -</h1>"
echo "<FONT SIZE=2 COLOR=Black>"
echo "<pre>$cmd</pre>"
echo "</body>"
echo "</html>"
