#!/usr/bin/python3
# -*- coding: utf-8 -*-
# sudo cp /usr/bin/vlc /usr/bin/vlc2
# sudo sed -i 's/geteuid/getppid/' /usr/bin/vlc2
# echo "%www-data ALL=NOPASSWD: /usr/bin/vlc2 *" | sudo tee -a /etc/sudoers

import os, subprocess

os.system("/usr/lib/cgi-bin/stop.py AAA")
command = "/usr/bin/sudo /usr/bin/vlc2 -I dummy -q --alsa-audio-device equal -LZ /root/mp3 --gain 1 </dev/null &>/dev/null"
try:
    returned_output = subprocess.Popen(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception as e:
    returned_output = e.output

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
print("<h1>Playing Random MP3...</h1>")
print("<h3><pre>" + str(command) + "</pre></h3>")
print("<h3><pre>" + str(returned_output) + "</pre></h3>")
print("</body>")
print("</html>")
