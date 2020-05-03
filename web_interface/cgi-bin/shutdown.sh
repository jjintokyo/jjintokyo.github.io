#!/bin/bash
#echo 'Content-type: text/plain'
#echo
#echo

/usr/bin/mpc stop &>/dev/null
sudo /home/pi/killemall
sudo shutdown -h

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<script type='text/javascript'>"
echo "    var timeleft = 60;"
echo "    var downloadTimer = setInterval(function(){"
echo "    timeleft--;"
echo "    document.getElementById('countdowntimer').textContent = timeleft;"
echo "    if(timeleft <= 0)"
echo "        clearInterval(downloadTimer);"
echo "    },1000);"
echo "</script>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Shutting down.....</h1>"
echo "<h1>Will begin in <span id='countdowntimer'>60 </span> seconds!</h1>"
echo "</body>"
echo "</html>"
