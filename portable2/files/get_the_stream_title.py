#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
import sys
import re
import struct
import urllib2

def write_message(title):
    cmd = 'echo ' + '"' + str(title) + '"' + ' | tee /tmp/url2.txt > /dev/null'
    os.system(cmd)
    sys.exit(0)

no_details = 'No Details Available!'
no_title = 'No Title Found!'
url = sys.argv[1]
try:
    request = urllib2.Request(url, headers={'Icy-MetaData': 1})
except:
    write_message(no_details)
try:
    response = urllib2.urlopen(request)
except:
    write_message(no_details)
print response.headers
try:
    metaint = int(response.headers['icy-metaint'])
except:
    write_message(no_title)
for _ in range(10):
    response.read(metaint)
    metadata_length = struct.unpack('B', response.read(1))[0] * 16
    metadata = response.read(metadata_length).rstrip(b'\0')
    print metadata
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
write_message(title)
