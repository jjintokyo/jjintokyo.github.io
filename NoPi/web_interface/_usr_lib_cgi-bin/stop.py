#!/usr/bin/python3
# -*- coding: utf-8 -*-
# echo "%www-data ALL=NOPASSWD: /usr/bin/pkill *" | sudo tee -a /etc/sudoers

import sys, os, subprocess

parameter = str(sys.argv[1]) if len(sys.argv) > 1 else ""
os.system("/usr/bin/mpc stop &>/dev/null")
os.system("/usr/bin/sudo /usr/bin/pkill softfm")
os.system("/usr/bin/sudo /usr/bin/pkill dab-rtlsdr-2")
os.system("/usr/bin/sudo /usr/bin/pkill welle-cli")
os.system("/usr/bin/sudo /usr/bin/pkill vlc2")
os.system("/usr/bin/sudo /usr/bin/pkill my_radio_song_feed_net.sh")
os.system("/usr/bin/sudo /usr/bin/pkill my_radio_song_feed_dab_1.sh")
os.system("/usr/bin/sudo /usr/bin/pkill my_radio_song_feed_dab_2.sh")
if parameter == "":
    command = "/usr/bin/mpc stop"
    try:
        returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    except Exception as e:
        returned_output = e.output

    print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
    print("<html>")
    print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
    print("<h1>Radio stopped...</h1>")
    print("<h3><pre>" + str(returned_output.decode('utf8')) + "</pre></h3>")
    print("</body>")
    print("</html>")
