#!/usr/bin/python3
# -*- coding: utf-8 -*-
# cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/cgi.load
# sudo usermod -a -G audio www-data
# echo "%www-data ALL=NOPASSWD: /usr/local/bin/dab-rtlsdr-2 *" | sudo tee -a /etc/sudoers
# sudo systemctl restart apache2

import cgi, cgitb, os, subprocess

cgitb.enable()
form = cgi.FieldStorage()
selection = form.getvalue("dab1.preset")
os.system("/usr/lib/cgi-bin/stop.py AAA")
command = "/usr/bin/sudo /usr/local/bin/dab-rtlsdr-2 " + selection + " -A equal &>/dev/null"
try:
    returned_output = subprocess.Popen(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except Exception as e:
    returned_output = e.output

print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
print("<html>")
print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
print("<h1>DAB1 Radio:</h1>")
print("<h3><pre>" + str(command) + "</pre></h3>")
print("<h3><pre>" + str(returned_output) + "</pre></h3>")
print("</body>")
print("</html>")
