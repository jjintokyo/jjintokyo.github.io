#!/bin/sh

/usr/share/apache2/cgi-bin/shutdown2.sh &

echo "Content-Type: text/html"
echo ""
echo "<html>"
echo "<script type='text/javascript'>"
echo "    var timeleft = 10;"
echo "    var downloadTimer = setInterval(function(){"
echo "    timeleft--;"
echo "    document.getElementById('countdowntimer').textContent = timeleft;"
echo "    if(timeleft <= 0)"
echo "        clearInterval(downloadTimer);"
echo "    },1000);"
echo "</script>"
echo "<body BGCOLOR=Lavender TEXT=Black>"
echo "<h1>Shutting down.....</h1>"
echo "<h1>Will begin in <span id='countdowntimer'>10 </span> seconds!</h1>"
echo "</body>"
echo "</html>"
