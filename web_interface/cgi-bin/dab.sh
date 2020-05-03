#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall
sudo /home/pi/radio2 2 "${QUERY_STRING}"

p=$(("${QUERY_STRING}"+1))
if [ "$p" -lt 10 ]; then
  p="0$p"
fi

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>DAB+ RADIO</h1>"
echo "<h1>Preset '$p'</h1>"
echo "</body>"
echo "</html>"
