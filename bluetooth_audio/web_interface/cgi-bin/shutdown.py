#!/usr/bin/python3
# -*- coding: utf-8 -*-
# echo "%www-data ALL=NOPASSWD: /usr/sbin/shutdown *" | sudo tee -a /etc/sudoers

import os, subprocess

os.system("/usr/lib/cgi-bin/stop.py AAA")
command = "/usr/bin/sleep 15 && /usr/bin/sudo /usr/sbin/shutdown now"
try:
    returned_output = subprocess.Popen(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception as e:
    returned_output = e.output

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<script type='text/javascript'>")
print("    var timeleft = 60;")
print("    var downloadTimer = setInterval(function(){")
print("    timeleft--;")
print("    document.getElementById('countdowntimer').textContent = timeleft;")
print("    if(timeleft <= 0)")
print("        clearInterval(downloadTimer);")
print("    },1000);")
print("</script>")
print("<body background='../pix/background2.jpg' bgcolor='DimGray' text='Silver'>")
print("<h1>Shutting down.....</h1>")
print("<h1>Will begin in <span id='countdowntimer'>60 </span> seconds!</h1>")
print("</body>")
print("</html>")
