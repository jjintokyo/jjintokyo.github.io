#!/usr/bin/python3
# -*- coding: utf-8 -*-
# cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/cgi.load
# sudo systemctl restart apache2

import cgi, cgitb, os, subprocess

cgitb.enable()
form = cgi.FieldStorage()
ps = form.getvalue("net.preset")
os.system("/usr/lib/cgi-bin/stop.py AAA")
if ps is None:
    command = "/usr/bin/mpc play"
else:
    command = "/usr/bin/mpc play " + str(ps)
try:
    returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
except Exception as e:
    returned_output = e.output

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/background2.jpg' bgcolor='DimGray' text='Silver'>")
print("<font size=4>")
print("<h3><pre>" + str(returned_output.decode('utf8')) + "</pre></h3>")
print("</body>")
print("</html>")
