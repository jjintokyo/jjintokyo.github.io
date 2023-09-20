#!/usr/bin/python3
# -*- coding: utf-8 -*-

import subprocess

command = "/usr/bin/mpc prev"
try:
    returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
except Exception as e:
    returned_output = e.output

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
print("<h3><pre>" + str(returned_output.decode('utf8')) + "</pre></h3>")
print("</body>")
print("</html>")
