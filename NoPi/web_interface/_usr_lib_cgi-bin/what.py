#!/usr/bin/python3
# -*- coding: utf-8 -*-

import subprocess

def process_exists(process_name):
    try:
        returned_output = str(subprocess.check_output("/usr/bin/ps -A", shell=True, stderr=subprocess.STDOUT))
        if process_name in returned_output:
            return True
        else:
            return False
    except Exception as e:
        return False

url = ""
returned_output = ""
if process_exists("softfm"):
    what = "FM radio is playing..."
else:
    if process_exists("dab-rtlsdr-2"):
        what = "DAB1 radio is playing..."
    else:
        if process_exists("welle-cli"):
            what = "DAB2 radio is playing..."
        else:
            if process_exists("vlc2"):
                what = "Random MP3 is playing..."
            else:
                what = "INTERNET radio is playing..."
                command = "/usr/bin/mpc current -f %file%"
                try:
                    returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
                except Exception as e:
                    returned_output = e.output
                if str(returned_output.decode('utf8')) != "":
                    url = str(returned_output.decode('utf8'))
                    command = "/usr/bin/mpc status"
                    try:
                        returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
                    except Exception as e:
                        returned_output = e.output
                else:
                    what = "Nothing is playing!"

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
print("<h1>" + str(what) + "</h1>")
print("<font size=4>")
if url:
    print("<b>" + str(url) + "</b>")
if returned_output:
    print("<h3><pre>" + str(returned_output.decode('utf8')) + "</pre></h3>")
print("</body>")
print("</html>")
