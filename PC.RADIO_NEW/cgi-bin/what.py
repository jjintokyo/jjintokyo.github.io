#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import subprocess

command = r"C:\PC.RADIO\mpc.exe -f %file% current"

try:
    returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
except Exception, e:
    returned_output = str(e.output)

url = returned_output if returned_output != "" else "Nothing is playing!"

command = r"C:\PC.RADIO\mpc.exe status"

try:
    returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
except Exception, e:
    returned_output = str(e.output)

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='/pix/wood2.jpg' bgcolor='White' text='Black'>")
print("<font size=3>")
print("<b>" + str(url) + "</b>")
print("<h3><pre>" + returned_output + "</pre></h3>")
print("</body>")
print("</html>")
