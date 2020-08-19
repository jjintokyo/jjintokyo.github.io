#!/bin/sh

cmd1=$(/tmp/ubi1/random/random_run.sh)
cmd2=$(/usr/bin/mpc status)

echo $cmd1 | sudo tee /tmp/ubi1/random/url1.txt > /dev/null

echo "Content-Type: text/html; charset=UTF-8"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<FONT SIZE=4 COLOR=Blue>"
echo "<b>$cmd1</b><BR>"
echo "<FONT COLOR=Black>"
echo "<h3><pre>$cmd2</pre></h3>"
echo "</body>"
echo "</html>"
