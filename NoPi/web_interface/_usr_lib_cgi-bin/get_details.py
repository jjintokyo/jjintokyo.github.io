#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys, socket, subprocess, re, struct
import urllib.request as urllib2

def build_web_page(url, title, details):
    print("Content-Type: text/html; charset=UTF-8\r\n\r\n")
    print("<html>")
    print("<body background='../pix/wood2.jpg' bgcolor='BurlyWood' text='Black'>")
    print("<font size=3>")
    print("<b>" + str(url) + "</b><br><br>")
    print("<b>" + str(title) + "</b><br>")
    print("<pre>" + str(details) + "</pre>")
    print("</body>")
    print("</html>")
    sys.exit(0)

socket.setdefaulttimeout(30)
no_url = "Nothing is playing!"
no_title = "No Title Found!"
no_details = "No Details Available!"
encoding = 'latin1'
### encoding = 'utf8'
string_start = "StreamTitle='"
string_end = "';"
command = "/usr/bin/mpc current -f %file%"
try:
    returned_output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
except Exception as e:
    returned_output = e.output
if str(returned_output.decode('utf8')) == "":
    url = no_url
    title = ""
    details = ""
    build_web_page(url, title, details)
url = str(returned_output.decode('utf8'))
try:
    request = urllib2.Request(url, headers={'Icy-MetaData': 1})
except:
    title = no_details
    details = ""
    build_web_page(url, title, details)
try:
    response = urllib2.urlopen(request)
except:
    title = no_details
    details = ""
    build_web_page(url, title, details)
details = str(response.headers)
try:
    metaint = int(response.headers['icy-metaint'])
except:
    title = no_title
    build_web_page(url, title, details)

for _ in range(10):
    try:
        response.read(metaint)
        metadata_length = struct.unpack('B', response.read(1))[0] * 16
        metadata = response.read(metadata_length).rstrip(b'\0')
        line = str(metadata.decode(encoding, errors='replace'))
        details = details + line
    except:
        title = no_title
        break
    try:
        start_position = line.index(string_start)
    except:
        continue
    try:
        end_position = line.index(string_end)
    except:
        continue
    title = line[start_position + len(string_start): end_position].strip()
    if title:
        break
else:
    title = no_title

build_web_page(url, title, details)
