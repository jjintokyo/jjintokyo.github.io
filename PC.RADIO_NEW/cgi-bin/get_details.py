#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys
import socket
import subprocess
import re
import struct
import urllib2

def build_web_page(url, title, details):
    try:
        title_2 = unicode(str(title))
    except:
        title_2 = str(title.encode("Latin-1", "replace"))
    try:
        details_2 = unicode(str(details))
    except:
        details_2 = str(details.encode("Latin-1", "replace"))

    print("Content-Type: text/html; charset=Latin-1\r\n\r\n")
    print("<html>")
    print("<body background='/pix/wood2.jpg' bgcolor='White' text='Black'>")
    print("<font size=3>")
    print("<b>" + url + "</b><br><br>")
    print("<b>" + title_2 + "</b><br>")
    print("<pre>" + details_2 + "</pre>")
    print("</body>")
    print("</html>")
    sys.exit(0)

reload(sys)
sys.setdefaultencoding("Latin-1")
socket.setdefaulttimeout(60)
no_url = "Nothing is playing!"
no_title = "No Title Found!"
no_details = "No Details Available!"

command = r"C:\PC.RADIO\mpc.exe -f %file% current"

try:
    returned_output = subprocess.check_output(command, shell=False, stderr=subprocess.STDOUT)
except Exception, e:
    returned_output = str(e.output)

if returned_output == "":
    url = no_url
    title = ""
    details = ""
    build_web_page(url, title, details)

url = returned_output

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
        details = details + str(metadata)
    except:
        title = no_title
        break
    start = "StreamTitle='"
    end = "';"
    try:
        title = re.search('%s(.*)%s' % (start, end), metadata).group(1)
        title = re.sub("StreamUrl='.*?';", "", title).replace("';", "").replace("StreamUrl='", "")
        title = re.sub("&artist=.*", "", title)
        title = re.sub("http://.*", "", title)
        title.rstrip()
    except:
        title = no_title
    if title:
        break
    else:
        title = no_title

build_web_page(url, title, details)
